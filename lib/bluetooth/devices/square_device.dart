import 'dart:async';
import 'dart:typed_data';
import 'package:dartx/dartx.dart';
import 'package:flutter/services.dart';
import 'package:universal_ble/universal_ble.dart';
import '../square_constants.dart';
import '../messages/notification.dart';
import 'base_device.dart';
import '../../utils/keymap/buttons.dart';
import '../../utils/key_simulator.dart';

class SquareDevice extends BaseDevice {
  String? _lastValue;
  final _keySimulator = KeySimulator();
  String? _serviceUuid;
  String? _characteristicUuid;

  SquareDevice(BleDevice device) : super(device);

  @override
  String get customServiceId => _serviceUuid ?? SquareConstants.CHARACTERISTIC_UUID;

  @override
  bool get supportsEncryption => false;

  @override
  Future<void> connect() async {
    try {
      await UniversalBle.connect(device.deviceId);
      
      final services = await UniversalBle.discoverServices(device.deviceId);
      await _handleServices(services);
      
      await _subscribeToNotifications();
    } catch (e) {
      print('Error connecting to SQUARE device: $e');
      rethrow;
    }
  }

  @override
  Future<void> _handleServices(List<BleService> services) async {
    // Para el dispositivo SQUARE, buscamos el servicio que contiene la característica
    final service = services.firstWhere(
      (service) => service.characteristics.any((c) => c.uuid == SquareConstants.CHARACTERISTIC_UUID),
      orElse: () => throw Exception(
        'Service with characteristic ${SquareConstants.CHARACTERISTIC_UUID} not found for device SQUARE.\nWe found: ${services.map((s) => s.uuid).join(', ')}',
      ),
    );

    // Guardamos el UUID del servicio y la característica
    _serviceUuid = service.uuid;
    _characteristicUuid = SquareConstants.CHARACTERISTIC_UUID;
    
    // No necesitamos configurar el handshake para el dispositivo SQUARE
    isConnected = true;
  }

  Future<void> _subscribeToNotifications() async {
    if (_serviceUuid == null || _characteristicUuid == null) {
      throw Exception('Service or characteristic UUID not found');
    }
    
    await UniversalBle.setNotifiable(
      device.deviceId,
      _serviceUuid!,
      _characteristicUuid!,
      BleInputProperty.notification,
    );
  }

  @override
  void processCharacteristic(String characteristicUuid, List<int> value) {
    if (characteristicUuid == SquareConstants.CHARACTERISTIC_UUID) {
      _handleNotification(value);
    }
  }

  @override
  Future<List<ZwiftButton>?> processClickNotification(Uint8List message) async {
    // No necesitamos implementar esto para el dispositivo SQUARE
    return null;
  }

  void _handleNotification(List<int> data) {
    final fullValue = _bytesToHex(data);
    final currentValue = _extractButtonCode(fullValue);

    if (_lastValue != null) {
      final currentRelevantPart = fullValue.length >= 19 
          ? fullValue.substring(6, fullValue.length - 13)
          : fullValue.substring(6);
      final lastRelevantPart = _lastValue!.length >= 19
          ? _lastValue!.substring(6, _lastValue!.length - 13)
          : _lastValue!.substring(6);

      if (currentRelevantPart != lastRelevantPart) {
        final buttonName = SquareConstants.BUTTON_MAPPING[currentValue] ?? "No button pressed";
        if (buttonName != "No button pressed") {
          print('Button pressed: $buttonName (full hex: $fullValue, button code: $currentValue)');
          actionStreamInternal.add(LogNotification('Button pressed: $buttonName'));
          _simulateKeyPress(buttonName);
        } else {
          print('Unpressed button');
        }
      }
    }

    _lastValue = fullValue;
  }

  String _extractButtonCode(String hexValue) {
    if (hexValue.length >= 14) {
      final buttonCode = hexValue.substring(6, 14);
      if (SquareConstants.BUTTON_MAPPING.containsKey(buttonCode)) {
        return buttonCode;
      }
    }
    return hexValue;
  }

  String _bytesToHex(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  void _simulateKeyPress(String buttonName) {
    final key = SquareConstants.KEY_MAPPING[buttonName];
    if (key != null) {
      print('Simulating key press: $key');
      _keySimulator.simulateKeyPress(key);
    }
  }

  @override
  Future<void> disconnect() async {
    if (_serviceUuid != null && _characteristicUuid != null) {
      await UniversalBle.setNotifiable(
        device.deviceId,
        _serviceUuid!,
        _characteristicUuid!,
        BleInputProperty.notification,
      );
    }
    await UniversalBle.disconnect(device.deviceId);
  }
} 
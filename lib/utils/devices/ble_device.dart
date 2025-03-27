import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:swift_play/utils/ble.dart';
import 'package:swift_play/utils/crypto/local_key_provider.dart';
import 'package:swift_play/utils/devices/zwift_click.dart';
import 'package:swift_play/utils/devices/zwift_play.dart';

import '../crypto/zap_crypto.dart';

abstract class BleDevice {
  final ScanResult scanResult;
  final zapEncryption = ZapCrypto(LocalKeyProvider());

  bool supportsEncryption = true;

  BleDevice(this.scanResult);

  static BleDevice? fromScanResult(ScanResult scanResult) {
    final manufacturerData = scanResult.advertisementData.manufacturerData;
    final data = manufacturerData[Constants.ZWIFT_MANUFACTURER_ID];
    if (data == null || data.isEmpty) {
      return null;
    }
    final type = DeviceType.fromManufacturerData(data.first);
    return switch (type) {
      DeviceType.click => ZwiftClick(scanResult),
      DeviceType.playRight => ZwiftPlay(scanResult),
      DeviceType.playLeft => ZwiftPlay(scanResult),
      _ => null,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BleDevice && runtimeType == other.runtimeType && scanResult == other.scanResult;

  @override
  int get hashCode => scanResult.hashCode;

  @override
  String toString() {
    return runtimeType.toString();
  }

  BluetoothDevice get device => scanResult.device;
  final StreamController<String> actionStreamInternal = StreamController<String>.broadcast();
  Stream<String> get actionStream => actionStreamInternal.stream;

  Future<void> connect() async {
    await device.connect(autoConnect: false).timeout(const Duration(seconds: 3));

    var filteredStateStream = device.connectionState.where((s) => s == BluetoothConnectionState.connected);

    // Start listening now, before invokeMethod, to ensure we don't miss the response
    Future<BluetoothConnectionState> futureState = filteredStateStream.first;

    // wait for connection
    await futureState.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('Failed to connect in time.');
      },
    );

    if (!kIsWeb && Platform.isAndroid) {
      await device.requestMtu(256);
    }
    final services = await device.discoverServices();

    await handleServices(services);
  }

  Future<void> handleServices(List<BluetoothService> services);
}

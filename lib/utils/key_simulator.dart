import 'dart:async';
import 'package:flutter/services.dart';
import 'package:keypress_simulator/keypress_simulator.dart';

class KeySimulator {
  static final KeySimulator _instance = KeySimulator._internal();
  factory KeySimulator() => _instance;
  KeySimulator._internal();

  final _keypressSimulator = keyPressSimulator;

  Future<void> simulateKeyPress(LogicalKeyboardKey key) async {
    try {
      final physicalKey = _getPhysicalKey(key);
      if (physicalKey != null) {
        await _keypressSimulator.simulateKeyDown(physicalKey);
        await _keypressSimulator.simulateKeyUp(physicalKey);
      }
    } catch (e) {
      print('Error simulating key press: $e');
    }
  }

  Future<void> simulateKeyDown(LogicalKeyboardKey key) async {
    try {
      final physicalKey = _getPhysicalKey(key);
      if (physicalKey != null) {
        await _keypressSimulator.simulateKeyDown(physicalKey);
      }
    } catch (e) {
      print('Error simulating key down: $e');
    }
  }

  Future<void> simulateKeyUp(LogicalKeyboardKey key) async {
    try {
      final physicalKey = _getPhysicalKey(key);
      if (physicalKey != null) {
        await _keypressSimulator.simulateKeyUp(physicalKey);
      }
    } catch (e) {
      print('Error simulating key up: $e');
    }
  }

  PhysicalKeyboardKey? _getPhysicalKey(LogicalKeyboardKey logicalKey) {
    // Mapeo de teclas lógicas a físicas
    switch (logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        return PhysicalKeyboardKey.arrowUp;
      case LogicalKeyboardKey.arrowDown:
        return PhysicalKeyboardKey.arrowDown;
      case LogicalKeyboardKey.arrowLeft:
        return PhysicalKeyboardKey.arrowLeft;
      case LogicalKeyboardKey.arrowRight:
        return PhysicalKeyboardKey.arrowRight;
      case LogicalKeyboardKey.enter:
        return PhysicalKeyboardKey.enter;
      case LogicalKeyboardKey.escape:
        return PhysicalKeyboardKey.escape;
      case LogicalKeyboardKey.space:
        return PhysicalKeyboardKey.space;
      case LogicalKeyboardKey.keyR:
        return PhysicalKeyboardKey.keyR;
      case LogicalKeyboardKey.keyG:
        return PhysicalKeyboardKey.keyG;
      case LogicalKeyboardKey.keyT:
        return PhysicalKeyboardKey.keyT;
      case LogicalKeyboardKey.digit1:
        return PhysicalKeyboardKey.digit1;
      case LogicalKeyboardKey.digit6:
        return PhysicalKeyboardKey.digit6;
      default:
        return null;
    }
  }
} 
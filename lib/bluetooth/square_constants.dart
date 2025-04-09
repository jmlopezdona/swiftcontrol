import 'package:flutter/services.dart';

class SquareConstants {
  static const String DEVICE_NAME = "SQUARE";
  static const String CHARACTERISTIC_UUID = "347b0043-7635-408b-8918-8ff3949ce592";
  static const int RECONNECT_DELAY = 5; // seconds between reconnection attempts

  // Button mapping
  static const Map<String, String> BUTTON_MAPPING = {
    "00000200": "Up",
    "00000100": "Left",
    "00000800": "Down",
    "00000400": "Right",
    "00002000": "X",
    "00001000": "Square",
    "00008000": "Left Campagnolo",
    "00004000": "Left brake",
    "00000002": "Left shift 1",
    "00000001": "Left shift 2",
    "02000000": "Y",
    "01000000": "A",
    "08000000": "B",
    "04000000": "Z",
    "20000000": "Circle",
    "10000000": "Triangle",
    "80000000": "Right Campagnolo",
    "40000000": "Right brake",
    "00020000": "Right shift 1",
    "00010000": "Right shift 2"
  };

  // Key mapping for button presses
  static const Map<String, LogicalKeyboardKey> KEY_MAPPING = {
    "Up": LogicalKeyboardKey.arrowUp,
    "Left": LogicalKeyboardKey.arrowLeft,
    "Down": LogicalKeyboardKey.arrowDown,
    "Right": LogicalKeyboardKey.arrowRight,
    "Square": LogicalKeyboardKey.keyR,
    "Left Campagnolo": LogicalKeyboardKey.arrowLeft,
    "Left brake": LogicalKeyboardKey.digit6,
    "Y": LogicalKeyboardKey.keyG,
    "A": LogicalKeyboardKey.enter,
    "B": LogicalKeyboardKey.escape,
    "Z": LogicalKeyboardKey.keyT,
    "Triangle": LogicalKeyboardKey.space,
    "Right Campagnolo": LogicalKeyboardKey.arrowRight,
    "Right brake": LogicalKeyboardKey.digit1,
  };
} 
import 'package:flutter/material.dart';

Color stringHexColorToColor(String hexColor) {
  if (hexColor.substring(0, 1) == '#') {
    hexColor = hexColor.substring(1);
  }
  hexColor = hexColor.substring(6, 8) + hexColor.substring(0, 6);
  return Color(int.parse(hexColor, radix: 16));
}

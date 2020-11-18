import 'package:flutter/material.dart';

class DiaTheme {
  static final Color primaryColor = Color(0xFF54728A);
  static final Color secondaryColor = Color(0xFFFC5A3A);

  static Map<int, Color> _primaryColorMap = {
    50: primaryColor.withOpacity(0.1),
    100: primaryColor.withOpacity(0.2),
    200: primaryColor.withOpacity(0.3),
    300: primaryColor.withOpacity(0.4),
    400: primaryColor.withOpacity(0.5),
    500: primaryColor.withOpacity(0.6),
    600: primaryColor.withOpacity(0.7),
    700: primaryColor.withOpacity(0.8),
    800: primaryColor.withOpacity(0.9),
    900: primaryColor.withOpacity(1.0),
  };

  static Map<int, Color> _secondaryColorMap = {
    50: secondaryColor.withOpacity(0.1),
    100: secondaryColor.withOpacity(0.2),
    200: secondaryColor.withOpacity(0.3),
    300: secondaryColor.withOpacity(0.4),
    400: secondaryColor.withOpacity(0.5),
    500: secondaryColor.withOpacity(0.6),
    600: secondaryColor.withOpacity(0.7),
    700: secondaryColor.withOpacity(0.8),
    800: secondaryColor.withOpacity(0.9),
    900: secondaryColor.withOpacity(1.0),
  };

  static final Color primarySwatch = MaterialColor(primaryColor.value, _primaryColorMap);
  static final Color secondarySwatch = MaterialColor(secondaryColor.value, _secondaryColorMap);

}

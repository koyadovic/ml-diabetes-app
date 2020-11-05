import 'package:flutter/material.dart';

double screenSizeScalingFactor(BuildContext context) {
  final size = MediaQuery.of(context).size;
  // For tiny devices.
  if (size.height < 600) {
    return 0.7;
  }
  // For normal devices.
  return 1.0;
}

double verySmallFontSize(BuildContext context) {
  double scalingFactor = screenSizeScalingFactor(context);
  return 12.0 * scalingFactor;
}

double smallFontSize(BuildContext context) {
  double scalingFactor = screenSizeScalingFactor(context);
  return 16.0 * scalingFactor;
}

double mediumFontSize(BuildContext context) {
  double scalingFactor = screenSizeScalingFactor(context);
  return 24.0 * scalingFactor;

}

double bigFontSize(BuildContext context) {
  double scalingFactor = screenSizeScalingFactor(context);
  return 30.0 * scalingFactor;
}

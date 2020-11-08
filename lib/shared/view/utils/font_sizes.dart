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

double verySmallSize(BuildContext context) {
  double scalingFactor = screenSizeScalingFactor(context);
  return 16.0 * scalingFactor;
}

double smallSize(BuildContext context) {
  double scalingFactor = screenSizeScalingFactor(context);
  return 20.0 * scalingFactor;
}

double mediumSize(BuildContext context) {
  double scalingFactor = screenSizeScalingFactor(context);
  return 26.0 * scalingFactor;

}

double bigSize(BuildContext context) {
  double scalingFactor = screenSizeScalingFactor(context);
  return 34.0 * scalingFactor;
}

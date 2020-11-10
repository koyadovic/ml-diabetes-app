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

double verySmallSize(BuildContext context, {bool scale: true}) {
  if(!scale) return 14.0;
  double scalingFactor = screenSizeScalingFactor(context);
  return 14.0 * scalingFactor;
}

double smallSize(BuildContext context, {bool scale: true}) {
  if(!scale) return 18.0;
  double scalingFactor = screenSizeScalingFactor(context);
  return 18.0 * scalingFactor;
}

double mediumSize(BuildContext context, {bool scale: true}) {
  if(!scale) return 24.0;
  double scalingFactor = screenSizeScalingFactor(context);
  return 24.0 * scalingFactor;
}

double bigSize(BuildContext context, {bool scale: true}) {
  if(!scale) return 32.0;
  double scalingFactor = screenSizeScalingFactor(context);
  return 32.0 * scalingFactor;
}

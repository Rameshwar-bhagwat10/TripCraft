import 'package:flutter/material.dart';

/// Centralized motion configuration for TripCraft animations.
abstract class AppMotion {
  const AppMotion._();

  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration emphasis = Duration(milliseconds: 350);

  // Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve enterCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;
  static const Curve emphasisCurve = Curves.fastOutSlowIn;
}

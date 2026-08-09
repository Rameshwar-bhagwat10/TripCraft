import 'package:flutter/material.dart';

/// Centralized subtle elevation and shadow specifications for TripCraft.
/// Clean, minimal, non-heavy shadows.
abstract class AppElevation {
  const AppElevation._();

  // Shadow definitions
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color.fromRGBO(15, 23, 42, 0.05), // Slate-900 at 5%
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color.fromRGBO(15, 23, 42, 0.08), // Slate-900 at 8%
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color.fromRGBO(15, 23, 42, 0.12), // Slate-900 at 12%
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: -2,
    ),
  ];
}

import 'package:flutter/material.dart';

/// Centralized dimensions, spacing tokens, and border radii for TripCraft.
abstract class AppDimensions {
  const AppDimensions._();

  // 1. Spacing Tokens (8-point grid system with steps)
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space28 = 28.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Semantic Spacing Names
  static const double xs = space4;
  static const double sm = space8;
  static const double md = space12;
  static const double lg = space16;
  static const double xl = space20;
  static const double xxl = space24;
  static const double section = space32;
  static const double pageMargin = space16;
  static const double heroPadding = space48;

  // 2. Border Radius Tokens
  static const double radiusXS = 6.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusPill = 999.0;

  // Component Radius Specifications
  static const BorderRadius borderXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderSM = BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderXXL = BorderRadius.all(Radius.circular(radiusXXL));
  static const BorderRadius borderPill = BorderRadius.all(Radius.circular(radiusPill));

  // Defaults for components
  static const BorderRadius buttonRadius = borderMD; // 12
  static const BorderRadius inputRadius = borderMD; // 12
  static const BorderRadius cardRadius = borderLG; // 16
  static const BorderRadius bottomSheetRadius = BorderRadius.vertical(top: Radius.circular(radiusXXL)); // 24

  // 3. Component Heights & Sizes
  static const double buttonHeight = 48.0;
  static const double buttonHeightCompact = 36.0;
  static const double inputHeight = 48.0;
  static const double minTouchTarget = 48.0;
  static const double bottomSheetHandleWidth = 32.0;
  static const double bottomSheetHandleHeight = 4.0;

  // 4. Icon Sizes
  static const double iconXS = 16.0;
  static const double iconSM = 18.0;
  static const double iconMD = 20.0;
  static const double iconLG = 24.0;
  static const double iconXL = 28.0;
  static const double iconXXL = 32.0;

  // 5. Avatar Sizes
  static const double avatarSM = 32.0;
  static const double avatarMD = 40.0;
  static const double avatarLG = 56.0;
  static const double avatarXL = 72.0;
}
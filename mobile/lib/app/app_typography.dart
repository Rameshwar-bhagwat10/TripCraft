import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typography scale for TripCraft based on Plus Jakarta Sans.
abstract class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'PlusJakartaSans';

  // Base font style factory
  static TextStyle _baseStyle({
    required double fontSize,
    required double height,
    required FontWeight fontWeight,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      height: height / fontSize, // Height multiplier in Flutter
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Display Tier (700 Bold)
  static TextStyle get displayLarge => _baseStyle(
        fontSize: 48,
        height: 56,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get displayMedium => _baseStyle(
        fontSize: 40,
        height: 48,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get displaySmall => _baseStyle(
        fontSize: 32,
        height: 40,
        fontWeight: FontWeight.w700,
      );

  // Headline Tier (700 Bold)
  static TextStyle get headlineLarge => _baseStyle(
        fontSize: 32,
        height: 40,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMedium => _baseStyle(
        fontSize: 28,
        height: 36,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineSmall => _baseStyle(
        fontSize: 24,
        height: 32,
        fontWeight: FontWeight.w700,
      );

  // Title Tier (600 SemiBold)
  static TextStyle get titleLarge => _baseStyle(
        fontSize: 20,
        height: 28,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMedium => _baseStyle(
        fontSize: 18,
        height: 24,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleSmall => _baseStyle(
        fontSize: 16,
        height: 22,
        fontWeight: FontWeight.w600,
      );

  // Body Tier (400 Regular)
  static TextStyle get bodyLarge => _baseStyle(
        fontSize: 16,
        height: 24,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMedium => _baseStyle(
        fontSize: 14,
        height: 20,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodySmall => _baseStyle(
        fontSize: 13,
        height: 18,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get caption => _baseStyle(
        fontSize: 12,
        height: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
      );

  // Label Tier (500 Medium)
  static TextStyle get labelLarge => _baseStyle(
        fontSize: 14,
        height: 20,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelMedium => _baseStyle(
        fontSize: 12,
        height: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelSmall => _baseStyle(
        fontSize: 11,
        height: 14,
        fontWeight: FontWeight.w500,
      );

  // Button Label (600 SemiBold)
  static TextStyle get buttonLabel => _baseStyle(
        fontSize: 14,
        height: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  /// Generates the standard Flutter [TextTheme] based on Plus Jakarta Sans
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
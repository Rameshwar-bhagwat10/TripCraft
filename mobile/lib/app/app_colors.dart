import 'package:flutter/material.dart';

/// Centralized semantic color tokens for TripCraft design system.
/// Pure light theme palette as specified by Phase 2 design system requirements.
abstract class AppColors {
  // Prevent instantiation
  const AppColors._();

  // 1. Primary Brand (Teal)
  static const Color primary = Color(0xFF0F766E);
  static const Color primaryDark = Color(0xFF115E59);
  static const Color primaryLight = Color(0xFFCCFBF1);
  static const Color primarySurface = Color(0xFFF0FDFA);

  // 2. Neutral Palette (Slate)
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF1F5F9);
  static const Color surfaceTertiary = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  // 3. Text Neutrals
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);

  // 4. Semantic Status Colors
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFDBEAFE);

  // 5. Travel Accent (Sun / Highlights)
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFEF3C7);

  // 6. AI Accent (Copilot & Intelligence)
  static const Color aiAccent = Color(0xFF7C3AED);
  static const Color aiAccentLight = Color(0xFFF3E8FF);
}
import 'package:flutter/material.dart';

class AppColors {
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0986FF),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD6E3FF),
    onPrimaryContainer: Color(0xFF001B3D),
    secondary: Color(0xFF001A49),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDAE2FF),
    onSecondaryContainer: Color(0xFF001946),
    tertiary: Color(
      0xFF28A745,
    ), // Fresh, natural green (slightly deeper than Apple green)
    onTertiary: Color(0xFFFFFFFF), // White for contrast
    tertiaryContainer: Color(0xFFD2F4D7), // Soft mint background for highlights
    onTertiaryContainer: Color(0xFF002107),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFF9F9FF),
    onSurface: Color(0xFF191C20),
    surfaceContainerHighest: Color(0xFFE2E2E9),
    onSurfaceVariant: Color(0xFF43474E),
    outline: Color(0xFF74777F),
    onInverseSurface: Color(0xFFF0F0F7),
    inverseSurface: Color(0xFF2E3035),
    inversePrimary: Color(0xFFA9C7FF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF405F90),
    outlineVariant: Color(0xFFC4C6CF),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF0986FF),
    onPrimary: Color(0xFF001B3D),
    primaryContainer: Color(0xFF264777),
    onPrimaryContainer: Color(0xFFD6E3FF),
    secondary: Color(0xFFB1C5FF),
    onSecondary: Color(0xFF162E60),
    secondaryContainer: Color(0xFF2F4578),
    onSecondaryContainer: Color(0xFFDAE2FF),
    tertiary: Color(
      0xFF28A745,
    ), // Fresh, natural green (slightly deeper than Apple green)
    onTertiary: Color(0xFFFFFFFF), // White for contrast
    tertiaryContainer: Color(0xFFD2F4D7), // Soft mint background for highlights
    onTertiaryContainer: Color(0xFFB9F0B8),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF111318),
    onSurface: Color(0xFFE2E2E9),
    surfaceContainerHighest: Color(0xFF43474E),
    onSurfaceVariant: Color(0xFFC4C6CF),
    outline: Color(0xFF8E9099),
    onInverseSurface: Color(0xFF191C20),
    inverseSurface: Color(0xFFE2E2E9),
    inversePrimary: Color(0xFF405F90),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFA9C7FF),
    outlineVariant: Color(0xFF43474E),
    scrim: Color(0xFF000000),
  );

  // Custom colors for expense categories
  static const Color foodColor = Color(0xFFFF6B6B);
  static const Color transportColor = Color(0xFF4ECDC4);
  static const Color entertainmentColor = Color(0xFF45B7D1);
  static const Color shoppingColor = Color(0xFF96CEB4);
  static const Color billsColor = Color(0xFFFECA57);
  static const Color othersColor = Color(0xFFFF9FF3);

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return foodColor;
      case 'transport':
        return transportColor;
      case 'entertainment':
        return entertainmentColor;
      case 'shopping':
        return shoppingColor;
      case 'bills':
        return billsColor;
      default:
        return othersColor;
    }
  }
}

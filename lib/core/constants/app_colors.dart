import 'package:flutter/material.dart';

// ============================================================================
// APP COLORS - Centralized Color Constants
// ============================================================================
//
// PURPOSE:
// - All app colors in one place
// - Easy theming support (light/dark)
// - Consistent color usage across the app
//
// USAGE:
// import 'package:app/core/constants/app_colors.dart';
// Container(color: AppColors.primary)
//
// THEMING:
// - Primary colors are used for main actions and branding
// - Semantic colors (success, error, etc.) convey meaning 0xFF2196F3
// ============================================================================

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF015790);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);

  // Secondary Colors
  static const Color secondary = Color(0xFF26A69A);
  static const Color secondaryLight = Color(0xFF80CBC4);
  static const Color secondaryDark = Color(0xFF00897B);

  // Accent Colors
  static const Color accent = Color(0xFFFF7043);
  static const Color accentLight = Color(0xFFFFAB91);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFA5D6A7);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFEF9A9A);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF90CAF9);

  // Text Colors
  static const Color textPrimary = grey900;
  static const Color textSecondary = grey600;
  static const Color textHint = grey500;
  static const Color textOnPrimary = Colors.white;

  // Background Colors
  static const Color background = white;
  static const Color backgroundSecondary = grey50;
  static const Color surface = white;
  static const Color surfaceVariant = grey100;

  // Border Colors
  static const Color border = grey300;
  static const Color divider = grey200;

  // Rating Colors
  static const Color rating = Color(0xFFFFC107);
  static const Color ratingEmpty = grey300;

  // Status Colors
  static const Color confirmed = success;
  static const Color pending = warning;
  static const Color cancelled = error;
  static const Color completed = info;
}

// Dark Theme Colors - Professional Dark Mode Palette
class AppColorsDark {
  AppColorsDark._();

  // =========================================================================
  // PRIMARY COLORS (Brand Consistency)
  // =========================================================================
  static const Color primary = Color(0xFF2196F3); // Bright Blue - Same as light
  static const Color primaryLight = Color(0xFF64B5F6); // Lighter Blue
  static const Color primaryDark = Color(0xFF1976D2); // Darker Blue
  static const Color primaryVariant =
      Color(0xFF0D47A1); // Deep Blue for accents

  // =========================================================================
  // SECONDARY COLORS (Supporting Palette)
  // =========================================================================
  static const Color secondary = Color(0xFF26A69A); // Teal
  static const Color secondaryLight = Color(0xFF80CBC4); // Light Teal
  static const Color secondaryDark = Color(0xFF00897B); // Dark Teal

  // =========================================================================
  // NEUTRAL COLORS (Professional Dark Scale)
  // =========================================================================
  // Deep backgrounds with subtle warmth
  static const Color grey50 = Color(0xFF0F0F0F); // Deepest background
  static const Color grey100 = Color(0xFF1A1A1A); // Card backgrounds
  static const Color grey200 = Color(0xFF252525); // Surface variants
  static const Color grey300 = Color(0xFF303030); // Borders and dividers
  static const Color grey400 = Color(0xFF424242); // Inactive elements
  static const Color grey500 = Color(0xFF616161); // Secondary text
  static const Color grey600 = Color(0xFF757575); // Hint text
  static const Color grey700 = Color(0xFF9E9E9E); // Light text on dark
  static const Color grey800 = Color(0xFFBDBDBD); // High contrast text
  static const Color grey900 = Color(0xFFE0E0E0); // Primary text

  // =========================================================================
  // SEMANTIC COLORS (Enhanced for Dark Mode)
  // =========================================================================
  static const Color success = Color(0xFF4CAF50); // Green - slightly brighter
  static const Color successLight = Color(0xFF81C784); // Light green
  static const Color successDark = Color(0xFF388E3C); // Dark green

  static const Color error = Color(0xFFF44336); // Red - same as light
  static const Color errorLight = Color(0xFFEF5350); // Light red
  static const Color errorDark = Color(0xFFD32F2F); // Dark red

  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color warningLight = Color(0xFFFFB74D); // Light orange
  static const Color warningDark = Color(0xFFF57C00); // Dark orange

  static const Color info = Color(0xFF2196F3); // Blue
  static const Color infoLight = Color(0xFF64B5F6); // Light blue
  static const Color infoDark = Color(0xFF1976D2); // Dark blue

  // =========================================================================
  // TEXT COLORS (Optimized for Dark Mode)
  // =========================================================================
  static const Color textPrimary = grey900; // High contrast white
  static const Color textSecondary = grey700; // Medium contrast
  static const Color textHint = grey500; // Low contrast
  static const Color textDisabled = grey400; // Disabled state
  static const Color textOnPrimary = Colors.white;

  // =========================================================================
  // BACKGROUND COLORS (Layered Hierarchy)
  // =========================================================================
  static const Color background = grey50; // Main app background
  static const Color backgroundSecondary = grey100; // Secondary backgrounds
  static const Color surface = grey100; // Cards, dialogs, sheets
  static const Color surfaceVariant = grey200; // Variant surfaces

  // =========================================================================
  // BORDER & DIVIDER COLORS
  // =========================================================================
  static const Color border = grey300; // Subtle borders
  static const Color borderLight = grey200; // Lighter borders
  static const Color divider = grey300; // Dividers

  // =========================================================================
  // INTERACTION COLORS (Enhanced States)
  // =========================================================================
  static const Color hover = grey200; // Hover state
  static const Color focus = primaryLight; // Focus ring
  static const Color pressed = grey400; // Pressed state
  static const Color selected =
      Color(0x332196F3); // Selected state (primary with 20% opacity)

  // =========================================================================
  // SPECIAL COLORS (Dark Mode Specific)
  // =========================================================================
  static const Color shadow = Color(0xFF000000); // Shadow color
  static const Color overlay = Color(0x80000000); // Overlay for modals
  static const Color scrim = Color(0xB3000000); // Backdrop scrim

  // =========================================================================
  // RATING & ACCENT COLORS
  // =========================================================================
  static const Color rating = Color(0xFFFFC107); // Gold for ratings
  static const Color ratingEmpty = grey400; // Empty rating stars

  // =========================================================================
  // STATUS COLORS (Enhanced)
  // =========================================================================
  static const Color confirmed = success;
  static const Color pending = warning;
  static const Color cancelled = error;
  static const Color completed = info;
}

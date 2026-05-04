// ============================================================================
// APP DIMENSIONS - Spacing and Sizing Constants
// ============================================================================
//
// PURPOSE:
// - Centralized sizing and spacing values
// - Consistent UI across the app
// - Easy to adjust globally
//
// USAGE:
// import 'package:app/core/constants/app_dimensions.dart';
// SizedBox(height: AppSpacing.md)
//
// ============================================================================

class AppSpacing {
  AppSpacing._();

  // Base spacing values (multiples of 4)
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Padding
  static const double paddingXs = xs;
  static const double paddingSm = sm;
  static const double paddingMd = md;
  static const double paddingLg = lg;
  static const double paddingXl = xl;
  static const double paddingScreen = md;

  // Margin
  static const double marginXs = xs;
  static const double marginSm = sm;
  static const double marginMd = md;
  static const double marginLg = lg;
  static const double marginXl = xl;

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 999.0;

  // Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Avatar Sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 96.0;

  // Button Heights
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;

  // Card Elevation
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
}

class AppSizes {
  AppSizes._();

  // Border Width
  static const double borderWidth = 1.0;
  static const double borderWidthThick = 2.0;

  // Divider Height
  static const double dividerHeight = 1.0;

  // Icon Sizes
  static const double iconSize = 24.0;

  // Max widths
  static const double maxContentWidth = 600.0;
  static const double maxCardWidth = 400.0;

  // Min heights
  static const double minButtonHeight = 48.0;
  static const double minTapTarget = 48.0;
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// App Theme Configuration
///
/// Provides light and dark theme configurations
/// following Material Design 3 guidelines
class AppTheme {
  AppTheme._();

  // =========================================================================
  // LIGHT THEME
  // =========================================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // Text Theme
      textTheme: _buildTextTheme(Brightness.light),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.primary),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.tajawal(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.tajawal(
          color: AppColors.textHint,
          fontSize: 14,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primaryLight,
        labelStyle: GoogleFonts.tajawal(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey800,
        contentTextStyle: GoogleFonts.tajawal(
          color: AppColors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.divider,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.grey400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.3);
          }
          return AppColors.grey300;
        }),
      ),
    );
  }

  // =========================================================================
  // DARK THEME
  // =========================================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: AppColorsDark.background,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColorsDark.background,
        foregroundColor: AppColorsDark.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shadowColor: AppColorsDark.shadow,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColorsDark.textPrimary,
        ),
      ),

      // Text Theme
      textTheme: _buildTextTheme(Brightness.dark),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColorsDark.surface,
        shadowColor: AppColorsDark.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColorsDark.borderLight.withOpacity(0.5)),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: AppColorsDark.shadow,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColorsDark.pressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColorsDark.hover;
            }
            return null;
          }),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.primary),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColorsDark.pressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColorsDark.hover;
            }
            return null;
          }),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.tajawal(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColorsDark.pressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColorsDark.hover;
            }
            return null;
          }),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColorsDark.borderLight),
        ),
        hintStyle: GoogleFonts.tajawal(
          color: AppColorsDark.textHint,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.tajawal(
          color: AppColorsDark.textSecondary,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.tajawal(
          color: AppColors.error,
          fontSize: 12,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColorsDark.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColorsDark.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColorsDark.divider,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColorsDark.surfaceVariant,
        selectedColor: AppColors.primaryDark,
        labelStyle: GoogleFonts.tajawal(
          fontSize: 12,
          color: AppColorsDark.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColorsDark.surface,
        contentTextStyle: GoogleFonts.tajawal(
          color: AppColorsDark.textPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColorsDark.surface,
        elevation: 8,
        shadowColor: AppColorsDark.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColorsDark.textPrimary,
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColorsDark.textSecondary,
        indicatorColor: AppColors.primary,
        labelStyle: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColorsDark.divider,
        circularTrackColor: AppColorsDark.divider,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColorsDark.grey400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.3);
          }
          return AppColorsDark.grey600;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColorsDark.border;
        }),
      ),
    );
  }

  // =========================================================================
  // COLOR SCHEMES
  // =========================================================================

  static ColorScheme get _lightColorScheme {
    return const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryLight,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.white,
      outline: AppColors.border,
    );
  }

  static ColorScheme get _darkColorScheme {
    return const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColorsDark.primaryVariant,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColorsDark.secondaryDark,
      onSecondaryContainer: AppColors.white,
      tertiary: AppColors.accent,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.accent,
      onTertiaryContainer: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColorsDark.errorDark,
      onErrorContainer: AppColors.white,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.textPrimary,
      surfaceContainerHighest: AppColorsDark.surfaceVariant,
      onSurfaceVariant: AppColorsDark.textSecondary,
      outline: AppColorsDark.border,
      outlineVariant: AppColorsDark.borderLight,
      shadow: AppColorsDark.shadow,
      scrim: AppColorsDark.scrim,
      inverseSurface: AppColorsDark.grey800,
      onInverseSurface: AppColorsDark.grey100,
      inversePrimary: AppColors.primaryLight,
      surfaceTint: AppColorsDark.primaryVariant,
    );
  }

  // =========================================================================
  // TEXT THEME
  // =========================================================================

  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? AppColors.textPrimary
        : AppColorsDark.textPrimary;

    return TextTheme(
      displayLarge: GoogleFonts.tajawal(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      displayMedium: GoogleFonts.tajawal(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      displaySmall: GoogleFonts.tajawal(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      headlineLarge: GoogleFonts.tajawal(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineMedium: GoogleFonts.tajawal(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineSmall: GoogleFonts.tajawal(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleLarge: GoogleFonts.tajawal(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleSmall: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyLarge: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodySmall: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      labelLarge: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      labelMedium: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      labelSmall: GoogleFonts.tajawal(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  // =========================================================================
  // STATIC COLOR GETTERS
  // =========================================================================

  static Color get primaryBlue => AppColors.primary;
  static Color get secondaryBlue => AppColors.secondary;
}

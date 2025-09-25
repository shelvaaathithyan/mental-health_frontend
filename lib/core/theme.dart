import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette inspired by the splash/loading sequence visuals.
class FreudColors {
  FreudColors._();

  static const Color cream = Color(0xFFF5EFE6);
  static const Color richBrown = Color(0xFF4B2E21);
  static const Color cocoa = Color(0xFF7A4B32);
  static const Color burntOrange = Color(0xFFF57C1F);
  static const Color mossGreen = Color(0xFF6C8A3C);
  static const Color paleOlive = Color(0xFFC4D88F);
  static const Color sunshine = Color(0xFFFFC85B);
  static const Color textDark = Color(0xFF2F1D12);
  static const Color textLight = Color(0xFFFDF7EF);
  static const Color error = Color(0xFFD64545);
}

class FreudTypography {
  FreudTypography._();

  static TextTheme build(TextTheme base) {
    final themed = GoogleFonts.manropeTextTheme(base);
    return themed.copyWith(
      displayLarge: themed.displayLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: FreudColors.textDark,
        height: 1.2,
      ),
      displayMedium: themed.displayMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: FreudColors.textDark,
        height: 1.25,
      ),
      displaySmall: themed.displaySmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: FreudColors.textDark,
        height: 1.3,
      ),
      headlineMedium: themed.headlineMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: FreudColors.textDark,
      ),
      bodyLarge: themed.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: FreudColors.textDark,
        height: 1.5,
      ),
      bodyMedium: themed.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: FreudColors.textDark.withValues(alpha: 0.8),
        height: 1.5,
      ),
      bodySmall: themed.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: FreudColors.textDark.withValues(alpha: 0.7),
      ),
      labelLarge: themed.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: FreudColors.textLight,
        letterSpacing: 0.4,
      ),
    );
  }
}

class FreudTheme {
  FreudTheme._();

  static ThemeData light() {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    final textTheme = FreudTypography.build(base.textTheme);

    final scheme = ColorScheme.fromSeed(
      seedColor: FreudColors.richBrown,
      brightness: Brightness.light,
    ).copyWith(
      primary: FreudColors.richBrown,
      onPrimary: FreudColors.textLight,
      secondary: FreudColors.cocoa,
      onSecondary: FreudColors.textLight,
      tertiary: FreudColors.mossGreen,
      onTertiary: FreudColors.textLight,
      surface: FreudColors.cream,
      onSurface: FreudColors.textDark,
      surfaceContainerHighest: FreudColors.cream,
      surfaceTint: Colors.transparent,
      error: FreudColors.error,
      onError: FreudColors.textLight,
      outline: FreudColors.cocoa,
      outlineVariant: FreudColors.cocoa,
      inverseSurface: FreudColors.richBrown,
      onInverseSurface: FreudColors.textLight,
      inversePrimary: FreudColors.mossGreen,
    );

    return base.copyWith(
      scaffoldBackgroundColor: FreudColors.cream,
      colorScheme: scheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: FreudColors.textDark,
        titleTextStyle: textTheme.headlineMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FreudColors.richBrown,
          foregroundColor: FreudColors.textLight,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FreudColors.richBrown,
          textStyle: textTheme.bodyMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide:
              BorderSide(color: FreudColors.textDark.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: FreudColors.richBrown, width: 1.4),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: FreudColors.textDark.withValues(alpha: 0.4),
        ),
      ),
      iconTheme: const IconThemeData(color: FreudColors.richBrown),
      dividerColor: FreudColors.textDark.withValues(alpha: 0.12),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FreudColors.richBrown,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: FreudColors.textLight,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

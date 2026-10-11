import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Builds the Material 3 [ThemeData] for Kora in light and dark variants.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.violet,
      secondary: AppColors.pink,
      surface: AppColors.lightSurface,
      error: AppColors.danger,
    );
    return _base(scheme, AppColors.lightBackground, AppColors.lightText,
        AppColors.lightMuted, AppColors.lightSurface, AppColors.lightBorder);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.violet,
      secondary: AppColors.pink,
      surface: AppColors.darkSurface,
      error: AppColors.danger,
    );
    return _base(scheme, AppColors.darkBackground, AppColors.darkText,
        AppColors.darkMuted, AppColors.darkSurface, AppColors.darkBorder);
  }

  static ThemeData _base(
    ColorScheme scheme,
    Color background,
    Color text,
    Color muted,
    Color surface,
    Color border,
  ) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme().apply(
      bodyColor: text,
      displayColor: text,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: text,
        ),
        iconTheme: IconThemeData(color: text),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: muted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.violet, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: AppColors.violet,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: text,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: .5),
        side: BorderSide.none,
        labelStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.violet,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      extensions: [
        KoraColors(
          muted: muted,
          border: border,
          surfaceAlt:
              scheme.brightness == Brightness.dark
                  ? AppColors.darkSurfaceAlt
                  : AppColors.lightSurfaceAlt,
          success: AppColors.success,
        ),
      ],
    );
  }
}

/// Theme extension exposing a few extra colours beyond [ColorScheme].
class KoraColors extends ThemeExtension<KoraColors> {
  const KoraColors({
    required this.muted,
    required this.border,
    required this.surfaceAlt,
    required this.success,
  });

  final Color muted;
  final Color border;
  final Color surfaceAlt;
  final Color success;

  @override
  KoraColors copyWith({
    Color? muted,
    Color? border,
    Color? surfaceAlt,
    Color? success,
  }) {
    return KoraColors(
      muted: muted ?? this.muted,
      border: border ?? this.border,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      success: success ?? this.success,
    );
  }

  @override
  KoraColors lerp(ThemeExtension<KoraColors>? other, double t) {
    if (other is! KoraColors) return this;
    return KoraColors(
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

/// Convenience accessor: `context.colors.muted`, `context.colors.border`, etc.
extension KoraColorsX on BuildContext {
  KoraColors get colors =>
      Theme.of(this).extension<KoraColors>() ??
      const KoraColors(
        muted: AppColors.lightMuted,
        border: AppColors.lightBorder,
        surfaceAlt: AppColors.lightSurfaceAlt,
        success: AppColors.success,
      );
}

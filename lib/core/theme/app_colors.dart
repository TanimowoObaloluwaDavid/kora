import 'package:flutter/material.dart';

/// Central colour palette for Kora.
///
/// The brand is built around a violet -> pink gradient with a mint accent.
class AppColors {
  AppColors._();

  // Brand
  static const Color violet = Color(0xFF6C4DF6);
  static const Color violetDark = Color(0xFF4B32C3);
  static const Color pink = Color(0xFFFF5C8A);
  static const Color mint = Color(0xFF2BE0A8);
  static const Color amber = Color(0xFFFFB020);
  static const Color sky = Color(0xFF38BDF8);

  // Light theme
  static const Color lightBackground = Color(0xFFF6F6FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF0EFF7);
  static const Color lightText = Color(0xFF14121F);
  static const Color lightMuted = Color(0xFF8A8899);
  static const Color lightBorder = Color(0xFFE7E5F0);

  // Dark theme
  static const Color darkBackground = Color(0xFF0C0B12);
  static const Color darkSurface = Color(0xFF17151F);
  static const Color darkSurfaceAlt = Color(0xFF211E2C);
  static const Color darkText = Color(0xFFF4F3FA);
  static const Color darkMuted = Color(0xFF9A97AC);
  static const Color darkBorder = Color(0xFF2A2735);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);

  /// The signature Kora gradient.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violet, Color(0xFF9B4DFF), pink],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mint, sky],
  );

  /// A soft, colourful gradient used for avatars / media placeholders.
  static LinearGradient gradientFor(String seed) {
    const List<List<Color>> palettes = [
      [Color(0xFF6C4DF6), Color(0xFFFF5C8A)],
      [Color(0xFF38BDF8), Color(0xFF6C4DF6)],
      [Color(0xFF2BE0A8), Color(0xFF38BDF8)],
      [Color(0xFFFF5C8A), Color(0xFFFFB020)],
      [Color(0xFFB44BFF), Color(0xFF38BDF8)],
      [Color(0xFFFF7A45), Color(0xFFFF5C8A)],
      [Color(0xFF12C2E9), Color(0xFFC471ED)],
    ];
    final index = seed.codeUnits.fold<int>(0, (a, b) => a + b) % palettes.length;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: palettes[index],
    );
  }
}

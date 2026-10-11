import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// A decorative gradient panel used as a stand-in for photos / media.
///
/// Draws a hashed brand gradient plus a few soft translucent shapes so each
/// seed looks distinct without needing image assets.
class GradientArt extends StatelessWidget {
  const GradientArt({
    super.key,
    required this.seed,
    this.child,
    this.borderRadius,
    this.icon,
  });

  final String seed;
  final Widget? child;
  final BorderRadius? borderRadius;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.gradientFor(seed)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -30,
              right: -20,
              child: _blob(120, Colors.white.withValues(alpha: .16)),
            ),
            Positioned(
              bottom: -50,
              left: -30,
              child: _blob(160, Colors.white.withValues(alpha: .10)),
            ),
            Positioned(
              top: 40,
              left: 30,
              child: _blob(50, Colors.white.withValues(alpha: .12)),
            ),
            if (icon != null)
              Center(
                child: Icon(
                  icon,
                  size: 54,
                  color: Colors.white.withValues(alpha: .28),
                ),
              ),
            ?child,
          ],
        ),
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

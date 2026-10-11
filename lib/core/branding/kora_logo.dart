import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The Kora brand mark: a gradient tile containing a stylised chat bubble with
/// a typing indicator. Drawn entirely with a [CustomPainter] so it scales
/// crisply to any size and needs no image assets.
class KoraLogo extends StatelessWidget {
  const KoraLogo({
    super.key,
    this.size = 64,
    this.showGlow = false,
    this.borderRadiusFactor = 0.3,
  });

  final double size;
  final bool showGlow;
  final double borderRadiusFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(size * borderRadiusFactor),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppColors.violet.withValues(alpha: .45),
                  blurRadius: size * 0.5,
                  spreadRadius: size * 0.06,
                ),
              ]
            : null,
      ),
      child: CustomPaint(painter: _ChatBubblePainter()),
    );
  }
}

class _ChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Back bubble (slightly translucent white) top-right.
    final backPaint = Paint()..color = Colors.white.withValues(alpha: .28);
    final back = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.40, h * 0.20, w * 0.42, h * 0.34),
      Radius.circular(w * 0.12),
    );
    canvas.drawRRect(back, backPaint);

    // Front bubble (solid white) with a tail.
    final frontPaint = Paint()..color = Colors.white;
    final frontRect = Rect.fromLTWH(w * 0.16, h * 0.34, w * 0.50, h * 0.36);
    final front = RRect.fromRectAndRadius(
      frontRect,
      Radius.circular(w * 0.14),
    );
    canvas.drawRRect(front, frontPaint);

    // Tail for the front bubble.
    final tail = Path()
      ..moveTo(w * 0.26, frontRect.bottom - h * 0.02)
      ..lineTo(w * 0.20, h * 0.82)
      ..lineTo(w * 0.40, frontRect.bottom - h * 0.02)
      ..close();
    canvas.drawPath(tail, frontPaint);

    // Three typing dots inside the front bubble.
    final dotPaint = Paint()..color = AppColors.violet;
    final dotR = w * 0.035;
    final cy = frontRect.center.dy;
    for (var i = 0; i < 3; i++) {
      final cx = frontRect.left + frontRect.width * (0.26 + i * 0.24);
      canvas.drawCircle(Offset(cx, cy), dotR, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The logo paired with the "Kora" wordmark.
class KoraWordmark extends StatelessWidget {
  const KoraWordmark({
    super.key,
    this.size = 64,
    this.vertical = false,
    this.textColor,
    this.tagline,
  });

  final double size;
  final bool vertical;
  final Color? textColor;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final word = Text(
      'Kora',
      style: TextStyle(
        fontSize: size * 0.55,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        color: textColor,
      ),
    );
    final mark = KoraLogo(size: size, showGlow: true);

    if (vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          mark,
          SizedBox(height: size * 0.28),
          word,
          if (tagline != null) ...[
            SizedBox(height: size * 0.1),
            Text(
              tagline!,
              style: TextStyle(
                fontSize: size * 0.2,
                color: textColor?.withValues(alpha: .7),
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [mark, SizedBox(width: size * 0.22), word],
    );
  }
}

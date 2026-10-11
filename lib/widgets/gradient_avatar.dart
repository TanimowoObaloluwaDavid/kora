import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/models/app_user.dart';

/// A circular avatar rendered from the user's name (initials on a hashed
/// gradient). No network images required.
class GradientAvatar extends StatelessWidget {
  const GradientAvatar({
    super.key,
    required this.user,
    this.size = 44,
    this.showOnline = false,
    this.ring = false,
    this.ringColor,
  });

  final AppUser user;
  final double size;
  final bool showOnline;
  final bool ring;
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.gradientFor(user.username),
      ),
      alignment: Alignment.center,
      child: Text(
        user.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
        ),
      ),
    );

    Widget content = avatar;
    if (ring) {
      content = Container(
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ringColor ?? AppColors.violet,
            width: 2,
          ),
        ),
        child: avatar,
      );
    }

    if (!showOnline) return content;

    return SizedBox(
      width: size + (ring ? 5 : 0),
      height: size + (ring ? 5 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.26,
              height: size * 0.26,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

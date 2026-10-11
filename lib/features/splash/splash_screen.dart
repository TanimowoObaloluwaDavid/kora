import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/branding/kora_logo.dart';
import '../../core/theme/app_colors.dart';

/// Animated branded splash. Fades + scales the logo in, then routes onward.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _timer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _PulseRing(
              controller: _controller,
              size: 260,
              delay: 0,
            ),
            _PulseRing(
              controller: _controller,
              size: 380,
              delay: 200,
            ),
            FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KoraLogo(size: 108, showGlow: true),
                    SizedBox(height: 28),
                    Text(
                      'Kora',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'CONNECT  ·  SHARE  ·  BELONG',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 56,
              child: FadeTransition(
                opacity: _fade,
                child: const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(Colors.white70),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Expanding, fading concentric ring used behind the logo.
class _PulseRing extends StatelessWidget {
  const _PulseRing({
    required this.controller,
    required this.size,
    required this.delay,
  });

  final AnimationController controller;
  final double size;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        (delay / 1200).clamp(0.0, 1.0),
        1.0,
        curve: Curves.easeOut,
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final value = animation.value;
        return Opacity(
          opacity: (1 - value) * 0.35,
          child: Container(
            width: size * (0.6 + value * 0.7),
            height: size * (0.6 + value * 0.7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        );
      },
    );
  }
}

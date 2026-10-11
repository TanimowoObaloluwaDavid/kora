import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/branding/kora_logo.dart';
import '../../widgets/gradient_art.dart';

class _OnboardPage {
  const _OnboardPage(this.icon, this.title, this.body, this.seed);
  final IconData icon;
  final String title;
  final String body;
  final String seed;
}

const List<_OnboardPage> _pages = [
  _OnboardPage(
    Icons.forum_rounded,
    'Connect with everyone',
    'Share your moments, follow the people you love, and never miss a beat.',
    'connect',
  ),
  _OnboardPage(
    Icons.bolt_rounded,
    'Chat in real time',
    'Fast, expressive conversations with typing indicators and read receipts.',
    'chat',
  ),
  _OnboardPage(
    Icons.explore_rounded,
    'Discover your vibe',
    'A feed tuned to your interests — save, like and share what moves you.',
    'discover',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  void _next() {
    if (_isLast) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                children: [
                  const KoraWordmark(size: 34),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      children: [
                        Expanded(
                          child: GradientArt(
                            seed: page.seed,
                            borderRadius: BorderRadius.circular(32),
                            child: Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .22),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  page.icon,
                                  size: 56,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: .6),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: active ? 26 : 8,
                        decoration: BoxDecoration(
                          gradient: active ? AppColors.brandGradient : null,
                          color: active
                              ? null
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _next,
                    child: Text(_isLast ? 'Get started' : 'Continue'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

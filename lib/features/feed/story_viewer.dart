import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/story.dart';
import '../../widgets/gradient_art.dart';

/// Full-screen story player with segmented progress and tap navigation.
class StoryViewer extends StatefulWidget {
  const StoryViewer({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  final List<Story> stories;
  final int initialIndex;

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _index;

  static const _duration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _next();
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index >= widget.stories.length - 1) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _index++);
    _controller.forward(from: 0);
  }

  void _previous() {
    if (_index == 0) {
      _controller.forward(from: 0);
      return;
    }
    setState(() => _index--);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_index];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final width = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < width / 3) {
            _previous();
          } else {
            _next();
          }
        },
        onLongPressStart: (_) => _controller.stop(),
        onLongPressEnd: (_) => _controller.forward(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GradientArt(
              seed: story.user.username,
              icon: Icons.auto_awesome_rounded,
            ),
            // Vignette overlays for legibility.
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 160,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: List.generate(widget.stories.length, (i) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, _) {
                                double value;
                                if (i < _index) {
                                  value = 1;
                                } else if (i > _index) {
                                  value = 0;
                                } else {
                                  value = _controller.value;
                                }
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: value,
                                    minHeight: 3,
                                    backgroundColor: Colors.white24,
                                    valueColor:
                                        const AlwaysStoppedAnimation(Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient:
                                AppColors.gradientFor(story.user.username),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            story.user.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          story.user.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '·  now',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: const Text(
                              'Send a reply...',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.favorite_border_rounded,
                            color: Colors.white),
                        const SizedBox(width: 12),
                        const Icon(Icons.send_rounded, color: Colors.white),
                      ],
                    ),
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

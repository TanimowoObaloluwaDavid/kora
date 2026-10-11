import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/app_user.dart';
import '../../../data/models/story.dart';

/// Horizontal stories strip shown at the top of the feed.
class StoriesBar extends StatelessWidget {
  const StoriesBar({
    super.key,
    required this.stories,
    required this.currentUser,
    required this.onOpen,
    required this.onAdd,
  });

  final List<Story> stories;
  final AppUser currentUser;
  final void Function(int index) onOpen;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          if (i == 0) {
            return _YourStory(initials: currentUser.initials, onTap: onAdd);
          }
          final story = stories[i - 1];
          return _StoryItem(
            story: story,
            onTap: () => onOpen(i - 1),
          );
        },
      ),
    );
  }
}

class _YourStory extends StatelessWidget {
  const _YourStory({required this.initials, required this.onTap});

  final String initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Your story',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({required this.story, required this.onTap});

  final Story story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final seen = story.seen;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: seen ? null : AppColors.brandGradient,
                color: seen
                    ? Theme.of(context).dividerColor
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientFor(story.user.username),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    story.user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.user.username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: seen ? FontWeight.w400 : FontWeight.w600,
                color: seen
                    ? Theme.of(context).colorScheme.onSurface.withValues(alpha: .6)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

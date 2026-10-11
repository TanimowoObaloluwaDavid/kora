import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/branding/kora_logo.dart';
import '../../state/app_state.dart';
import '../../state/theme_controller.dart';
import '../notifications/notifications_screen.dart';
import 'post_detail_screen.dart';
import 'story_viewer.dart';
import 'widgets/post_card.dart';
import 'widgets/stories_bar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = context.watch<ThemeController>();
    final unread = state.unreadNotifications;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              titleSpacing: 20,
              title: const KoraWordmark(size: 30, vertical: false),
              actions: [
                IconButton(
                  tooltip: theme.isDark ? 'Light mode' : 'Dark mode',
                  onPressed: theme.toggle,
                  icon: Icon(
                    theme.isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                    if (unread > 0)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5C8A),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 6),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  StoriesBar(
                    stories: state.stories,
                    currentUser: state.user,
                    onAdd: () {
                      state.addStory();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Story added to your circle')),
                      );
                    },
                    onOpen: (index) {
                      state.markStoriesSeen();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => StoryViewer(
                            stories: state.stories,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            SliverList.separated(
              itemCount: state.posts.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final post = state.posts[i];
                return PostCard(
                  post: post,
                  onOpen: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PostDetailScreen(postId: post.id),
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

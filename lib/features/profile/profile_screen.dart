import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/app_user.dart';
import '../../data/models/post.dart';
import '../../state/app_state.dart';
import '../../widgets/gradient_art.dart';
import '../../widgets/gradient_avatar.dart';
import '../../widgets/post_grid.dart';
import '../feed/post_detail_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

/// The current user's profile tab with Posts / Saved / Tagged tabs.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return _ProfileView(
      user: state.user,
      isMe: true,
      posts: state.myPosts.isEmpty ? state.posts.take(6).toList() : state.myPosts,
      saved: state.savedPosts,
      tagged: state.posts.where((p) => p.tags.isNotEmpty).take(6).toList(),
      onEdit: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const EditProfileScreen()),
      ),
      onSettings: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
      ),
    );
  }
}

/// A profile shown as its own route, used for other people.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theirPosts =
        state.posts.where((p) => p.author.id == user.id).toList();
    return _ProfileView(
      user: user,
      isMe: false,
      posts: theirPosts.isEmpty ? state.posts.take(4).toList() : theirPosts,
      saved: const [],
      tagged: state.posts.where((p) => p.tags.isNotEmpty).take(6).toList(),
      following: state.isFollowing(user.id),
      onFollow: () => state.toggleFollow(user.id),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({
    required this.user,
    required this.isMe,
    required this.posts,
    required this.saved,
    required this.tagged,
    this.onEdit,
    this.onSettings,
    this.onFollow,
    this.following = false,
  });

  final AppUser user;
  final bool isMe;
  final List<Post> posts;
  final List<Post> saved;
  final List<Post> tagged;
  final VoidCallback? onEdit;
  final VoidCallback? onSettings;
  final VoidCallback? onFollow;
  final bool following;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: .6);
    final tabs = isMe
        ? const ['Posts', 'Saved', 'Tagged']
        : const ['Posts', 'Media', 'Likes'];

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 130,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GradientArt(
                        seed: '${user.username}cover',
                        borderRadius: BorderRadius.zero,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: MediaQuery.of(context).padding.top + 4,
                        child: Row(
                          children: [
                            if (!isMe)
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.arrow_back_rounded,
                                    color: Colors.white),
                              ),
                            const Spacer(),
                            if (isMe && onSettings != null)
                              IconButton(
                                onPressed: onSettings,
                                icon: const Icon(Icons.settings_outlined,
                                    color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: -40,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: GradientAvatar(user: user, size: 84),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (user.isVerified)
                            const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(Icons.verified_rounded,
                                  size: 18, color: AppColors.sky),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('@${user.username}', style: TextStyle(color: muted)),
                      const SizedBox(height: 12),
                      Text(user.bio, style: const TextStyle(height: 1.45)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _Stat(value: compactNumber(user.posts), label: 'Posts'),
                          _Stat(
                            value: compactNumber(user.followers),
                            label: 'Followers',
                          ),
                          _Stat(
                            value: compactNumber(user.following),
                            label: 'Following',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (isMe)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: onEdit,
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                label: const Text('Edit profile'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton.filledTonal(
                              onPressed: () {},
                              icon: const Icon(Icons.ios_share_rounded),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: following
                                  ? OutlinedButton(
                                      onPressed: onFollow,
                                      child: const Text('Following'),
                                    )
                                  : FilledButton(
                                      onPressed: onFollow,
                                      child: const Text('Follow'),
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    Navigator.of(context).pushNamed('/home'),
                                icon: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 18),
                                label: const Text('Message'),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarHeader(
              TabBar(
                labelColor: Theme.of(context).colorScheme.onSurface,
                indicatorColor: AppColors.violet,
                tabs: tabs.map((t) => Tab(text: t)).toList(),
              ),
              Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ],
        body: TabBarView(
          children: [
            _grid(context, posts),
            _grid(context, isMe ? saved : tagged),
            _grid(context, tagged),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, List<Post> items) {
    if (items.isEmpty) {
      return const Center(child: Text('Nothing here yet'));
    }
    return PostGrid(
      posts: items,
      onTap: (post) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PostDetailScreen(postId: post.id),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: .6);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          Text(label, style: TextStyle(color: muted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _TabBarHeader extends SliverPersistentHeaderDelegate {
  _TabBarHeader(this.tabBar, this.background);

  final TabBar tabBar;
  final Color background;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      color: background,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarHeader old) =>
      old.tabBar != tabBar || old.background != background;
}

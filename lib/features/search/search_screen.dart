import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/app_user.dart';
import '../../state/app_state.dart';
import '../../widgets/gradient_art.dart';
import '../../widgets/gradient_avatar.dart';
import '../../widgets/section_title.dart';
import '../feed/post_detail_screen.dart';
import '../profile/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  static const _trending = [
    '#afrobeats',
    '#flutter',
    '#lagos',
    '#foodie',
    '#design',
    '#travel',
    '#art',
    '#fitness',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final results = state.searchUsers(_query);
    final searching = _query.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Text('Explore'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: TextField(
                  controller: _controller,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search people, tags or posts',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _controller.clear();
                              setState(() => _query = '');
                            },
                          ),
                  ),
                ),
              ),
            ),
            if (searching)
              _PeopleResults(results: results)
            else ...[
              const SectionTitle(title: 'Trending now'),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _trending
                        .map(
                          (t) => ActionChip(
                            label: Text(t),
                            avatar: const Icon(
                              Icons.trending_up_rounded,
                              size: 16,
                              color: AppColors.violet,
                            ),
                            onPressed: () {
                              _controller.text = t.substring(1);
                              setState(() => _query = t.substring(1));
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SectionTitle(title: 'People to follow'),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 176,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.suggestions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => _SuggestionCard(
                      user: state.suggestions[i],
                    ),
                  ),
                ),
              ),
              const SectionTitle(title: 'Explore'),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final post = state.posts[i % state.posts.length];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PostDetailScreen(postId: post.id),
                          ),
                        ),
                        child: GradientArt(
                          seed: post.id + post.author.username,
                          borderRadius: BorderRadius.circular(10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.favorite_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    compactNumber(post.likes),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.posts.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ],
        ),
      ),
    );
  }
}

class _PeopleResults extends StatelessWidget {
  const _PeopleResults({required this.results});

  final List<AppUser> results;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No people found',
          message: 'Try a different name or username.',
        ),
      );
    }
    return SliverList.builder(
      itemCount: results.length,
      itemBuilder: (context, i) => _UserTile(user: results[i]),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final following = state.isFollowing(user.id);
    return ListTile(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => UserProfileScreen(user: user)),
      ),
      leading: GradientAvatar(user: user, size: 46, showOnline: true),
      title: Row(
        children: [
          Flexible(
            child: Text(
              user.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          if (user.isVerified)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.verified_rounded,
                  size: 15, color: AppColors.sky),
            ),
        ],
      ),
      subtitle: Text('@${user.username} · ${compactNumber(user.followers)} followers'),
      trailing: following
          ? OutlinedButton(
              onPressed: () => state.toggleFollow(user.id),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: const Text('Following'),
            )
          : FilledButton(
              onPressed: () => state.toggleFollow(user.id),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Follow'),
            ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final following = state.isFollowing(user.id);
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientAvatar(user: user, size: 56),
          const SizedBox(height: 10),
          Text(
            user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          Text(
            '@${user.username}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .55),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: following
                ? OutlinedButton(
                    onPressed: () => state.toggleFollow(user.id),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Following'),
                  )
                : FilledButton(
                    onPressed: () => state.toggleFollow(user.id),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Follow'),
                  ),
          ),
        ],
      ),
    );
  }
}

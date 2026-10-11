import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/app_user.dart';
import '../../../data/models/post.dart';
import '../../../state/app_state.dart';
import '../../../widgets/gradient_art.dart';
import '../../../widgets/gradient_avatar.dart';

/// A single feed post with header, media, action row and caption.
class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post, this.onOpen});

  final Post post;
  final VoidCallback? onOpen;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  late final AnimationController _heart;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _heart = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _heart.dispose();
    super.dispose();
  }

  void _doubleTapLike() {
    final state = context.read<AppState>();
    if (!widget.post.liked) state.toggleLike(widget.post.id);
    setState(() => _showHeart = true);
    _heart.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = context.watch<AppState>().postById(widget.post.id) ?? widget.post;
    final state = context.read<AppState>();
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: .55);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              GradientAvatar(user: post.author, size: 42, showOnline: true),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            post.author.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (post.author.isVerified)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.verified_rounded,
                              size: 15,
                              color: AppColors.sky,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      post.location != null
                          ? '${post.location} · ${timeAgo(post.createdAt)}'
                          : '@${post.author.username} · ${timeAgo(post.createdAt)}',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
              _PostMenu(post: post),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.onOpen,
          onDoubleTap: _doubleTapLike,
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GradientArt(seed: post.id + post.author.username),
                if (_showHeart)
                  AnimatedBuilder(
                    animation: _heart,
                    builder: (context, child) {
                      final scale = 0.6 + _heart.value * 0.8;
                      return Transform.translate(
                        offset: Offset.zero,
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: (1 - _heart.value).clamp(0, 1),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: const Center(
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 110,
                        shadows: [
                          Shadow(color: Colors.black38, blurRadius: 24),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Row(
            children: [
              _ActionButton(
                icon: post.liked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: post.liked ? AppColors.pink : null,
                onTap: () => state.toggleLike(post.id),
              ),
              _ActionButton(
                icon: Icons.mode_comment_outlined,
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => _CommentsSheet(postId: post.id),
                ),
              ),
              _ActionButton(
                icon: Icons.send_rounded,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share sheet coming soon')),
                ),
              ),
              const Spacer(),
              _ActionButton(
                icon: post.saved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: post.saved ? AppColors.violet : null,
                onTap: () => state.toggleSave(post.id),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${compactNumber(post.likes)} likes',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: '${post.author.username} ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
              if (post.tags.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: post.tags
                      .map(
                        (t) => Text(
                          t,
                          style: const TextStyle(
                            color: AppColors.violet,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (post.comments > 0) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => _CommentsSheet(postId: post.id),
                  ),
                  child: Text(
                    'View all ${compactNumber(post.comments)} comments',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.onTap, this.color});

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 26, color: color),
      splashRadius: 22,
    );
  }
}

class _PostMenu extends StatelessWidget {
  const _PostMenu({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz_rounded),
      onSelected: (value) {
        final state = context.read<AppState>();
        switch (value) {
          case 'save':
            state.toggleSave(post.id);
          case 'unfollow':
            state.toggleFollow(post.author.id);
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$value — coming soon')),
            );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'save',
          child: Row(
            children: [
              Icon(post.saved
                  ? Icons.bookmark_remove_rounded
                  : Icons.bookmark_add_outlined),
              const SizedBox(width: 12),
              Text(post.saved ? 'Unsave' : 'Save'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.link_rounded),
              SizedBox(width: 12),
              Text('Copy link'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'unfollow',
          child: Row(
            children: [
              Icon(Icons.person_remove_outlined),
              SizedBox(width: 12),
              Text('Unfollow'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.flag_outlined),
              SizedBox(width: 12),
              Text('Report'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Comments bottom sheet (mock, with local optimistic add).
class _CommentsSheet extends StatefulWidget {
  const _CommentsSheet({required this.postId});

  final String postId;

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _controller = TextEditingController();
  final List<String> _comments = [
    'This is so good 🔥',
    'The lighting though 😍',
    'Teach me your ways!',
  ];

  static const _authors = ['tundebk', 'zaracodes', 'amaraeze'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _comments.insert(0, _controller.text.trim());
      _authors.insert(0, 'you');
    });
    context.read<AppState>().addComment(widget.postId);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().user;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _comments.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientAvatar(
                          user: AppUser(
                            id: _authors[i],
                            name: _authors[i],
                            username: _authors[i],
                          ),
                          size: 38,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _authors[i],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(_comments[i]),
                            ],
                          ),
                        ),
                        const Icon(Icons.favorite_border_rounded, size: 18),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  GradientAvatar(user: user, size: 38),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded, color: AppColors.violet),
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

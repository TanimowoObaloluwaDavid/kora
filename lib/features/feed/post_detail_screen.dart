import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/app_user.dart';
import '../../state/app_state.dart';
import '../../widgets/gradient_avatar.dart';
import 'widgets/post_card.dart';

/// Detail view for a single post: media, stats and a comment thread.
class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _controller = TextEditingController();
  final List<({String author, String text})> _comments = [
    (author: 'tundebk', text: 'The composition here is unreal 🔥'),
    (author: 'zaracodes', text: 'Saving this for inspiration!'),
    (author: 'ifelawson', text: 'Okay you need to drop the preset 🙏'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _comments.insert(0, (author: 'you', text: text)));
    context.read<AppState>().addComment(widget.postId);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final post = state.postById(widget.postId);
    if (post == null) {
      return const Scaffold(body: Center(child: Text('Post removed')));
    }
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: .55);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          IconButton(
            onPressed: () => state.toggleSave(post.id),
            icon: Icon(
              post.saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: post.saved ? AppColors.violet : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                PostCard(post: post),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        'Comments',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        compactNumber(post.comments),
                        style: TextStyle(color: muted),
                      ),
                    ],
                  ),
                ),
                ..._comments.map(
                  (c) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientAvatar(
                          user: AppUser(
                            id: c.author,
                            name: c.author,
                            username: c.author,
                          ),
                          size: 38,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.author,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(c.text),
                            ],
                          ),
                        ),
                        const Icon(Icons.favorite_border_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  GradientAvatar(user: state.user, size: 38),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
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
          ),
        ],
      ),
    );
  }
}

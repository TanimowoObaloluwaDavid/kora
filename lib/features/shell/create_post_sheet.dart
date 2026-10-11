import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/gradient_avatar.dart';
import '../../widgets/gradient_art.dart';

/// Bottom sheet for composing a new post.
class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final _controller = TextEditingController();
  final Set<String> _tags = {};
  bool _hasMedia = true;

  static const _availableTags = [
    '#life',
    '#design',
    '#music',
    '#food',
    '#travel',
    '#art',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canPost => _controller.text.trim().isNotEmpty;

  void _post() {
    context.read<AppState>().addPost(
          caption: _controller.text.trim(),
          tags: _tags.toList(),
        );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Posted to your feed 🎉')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().user;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'New post',
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientAvatar(user: user, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      maxLines: null,
                      minLines: 3,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
              if (_hasMedia) ...[
                const SizedBox(height: 8),
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: GradientArt(
                        seed: _controller.text.isEmpty
                            ? 'new-post'
                            : _controller.text,
                        borderRadius: BorderRadius.circular(18),
                        icon: Icons.image_rounded,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => _hasMedia = false),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _availableTags.map((tag) {
                  final selected = _tags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: selected,
                    onSelected: (v) => setState(() {
                      if (v) {
                        _tags.add(tag);
                      } else {
                        _tags.remove(tag);
                      }
                    }),
                    selectedColor: AppColors.violet.withValues(alpha: .18),
                    checkmarkColor: AppColors.violet,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => setState(() => _hasMedia = true),
                    icon: const Icon(Icons.image_outlined),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.location_on_outlined),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.gif_box_outlined),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _canPost ? _post : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(120, 52),
                    ),
                    child: const Text('Post'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

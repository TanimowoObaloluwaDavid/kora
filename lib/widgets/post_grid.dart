import 'package:flutter/material.dart';

import '../core/utils/formatters.dart';
import '../data/models/post.dart';
import 'gradient_art.dart';

/// A tappable 3-column grid of posts used on profile and explore screens.
class PostGrid extends StatelessWidget {
  const PostGrid({
    super.key,
    required this.posts,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  final List<Post> posts;
  final void Function(Post post)? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: posts.length,
      itemBuilder: (context, i) {
        final post = posts[i];
        return GestureDetector(
          onTap: onTap == null ? null : () => onTap!(post),
          child: GradientArt(
            seed: post.id + post.author.username,
            borderRadius: BorderRadius.circular(10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_rounded,
                        size: 13, color: Colors.white),
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
    );
  }
}

import 'app_user.dart';

/// A piece of content in the Kora feed.
class Post {
  const Post({
    required this.id,
    required this.author,
    required this.caption,
    required this.createdAt,
    this.tags = const [],
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.liked = false,
    this.saved = false,
    this.location,
  });

  final String id;
  final AppUser author;
  final String caption;
  final DateTime createdAt;
  final List<String> tags;
  final int likes;
  final int comments;
  final int shares;
  final bool liked;
  final bool saved;
  final String? location;

  Post copyWith({
    String? caption,
    int? likes,
    int? comments,
    int? shares,
    bool? liked,
    bool? saved,
  }) {
    return Post(
      id: id,
      author: author,
      caption: caption ?? this.caption,
      createdAt: createdAt,
      tags: tags,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      liked: liked ?? this.liked,
      saved: saved ?? this.saved,
      location: location,
    );
  }
}

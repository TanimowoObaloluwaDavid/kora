import 'app_user.dart';

/// A 24-hour story.
class Story {
  const Story({
    required this.user,
    this.seen = false,
    this.createdAt,
  });

  final AppUser user;
  final bool seen;
  final DateTime? createdAt;

  Story copyWith({bool? seen}) => Story(
        user: user,
        seen: seen ?? this.seen,
        createdAt: createdAt,
      );
}

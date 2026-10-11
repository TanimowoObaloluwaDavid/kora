/// A Kora user profile.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.username,
    this.bio = '',
    this.followers = 0,
    this.following = 0,
    this.posts = 0,
    this.isVerified = false,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String username;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final bool isVerified;
  final bool isOnline;

  /// Up to two uppercase initials derived from [name].
  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1 || parts[1].isEmpty) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
  }

  AppUser copyWith({
    String? name,
    String? username,
    String? bio,
    int? followers,
    int? following,
    int? posts,
    bool? isVerified,
    bool? isOnline,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

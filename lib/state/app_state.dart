import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../data/models/app_user.dart';
import '../data/models/chat.dart';
import '../data/models/notification_item.dart';
import '../data/models/post.dart';
import '../data/models/story.dart';

/// The single source of truth for the Kora demo app.
///
/// All mutations go through this class so the UI can stay dumb and reactive.
class AppState extends ChangeNotifier {
  AppState() {
    _posts = MockData.posts();
    _stories = MockData.stories();
    _threads = MockData.chatThreads();
    _notifications = MockData.notifications();
  }

  late List<Post> _posts;
  late List<Story> _stories;
  late List<ChatThread> _threads;
  late List<NotificationItem> _notifications;

  AppUser _user = MockData.currentUser;
  final Set<String> _following = {'u1', 'u3'};

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------
  AppUser get user => _user;
  List<Post> get posts => List.unmodifiable(_posts);
  List<Story> get stories => List.unmodifiable(_stories);
  List<ChatThread> get threads => List.unmodifiable(_threads);
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  List<Post> get savedPosts => _posts.where((p) => p.saved).toList();
  List<Post> get myPosts => _posts.where((p) => p.author.id == _user.id).toList();

  bool isFollowing(String userId) => _following.contains(userId);

  int get unreadChats =>
      _threads.fold(0, (sum, t) => sum + (t.unread > 0 ? 1 : 0));

  int get unreadNotifications =>
      _notifications.where((n) => !n.read).length;

  List<AppUser> get suggestions => MockData.users
      .where((u) => u.id != _user.id && !_following.contains(u.id))
      .take(4)
      .toList();

  List<AppUser> searchUsers(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return MockData.users;
    return MockData.users
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.username.toLowerCase().contains(q))
        .toList();
  }

  Post? postById(String id) {
    for (final p in _posts) {
      if (p.id == id) return p;
    }
    return null;
  }

  ChatThread? threadById(String id) {
    for (final t in _threads) {
      if (t.id == id) return t;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Feed actions
  // ---------------------------------------------------------------------------
  void toggleLike(String postId) {
    final i = _posts.indexWhere((p) => p.id == postId);
    if (i == -1) return;
    final p = _posts[i];
    _posts[i] = p.copyWith(
      liked: !p.liked,
      likes: p.liked ? p.likes - 1 : p.likes + 1,
    );
    notifyListeners();
  }

  void toggleSave(String postId) {
    final i = _posts.indexWhere((p) => p.id == postId);
    if (i == -1) return;
    _posts[i] = _posts[i].copyWith(saved: !_posts[i].saved);
    notifyListeners();
  }

  void addComment(String postId) {
    final i = _posts.indexWhere((p) => p.id == postId);
    if (i == -1) return;
    _posts[i] = _posts[i].copyWith(comments: _posts[i].comments + 1);
    notifyListeners();
  }

  void addPost({required String caption, List<String> tags = const []}) {
    _posts.insert(
      0,
      Post(
        id: 'p_${DateTime.now().microsecondsSinceEpoch}',
        author: _user,
        caption: caption,
        tags: tags,
        createdAt: DateTime.now(),
      ),
    );
    _user = _user.copyWith(posts: _user.posts + 1);
    notifyListeners();
  }

  void deletePost(String postId) {
    _posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Story actions
  // ---------------------------------------------------------------------------
  void markStoriesSeen() {
    var changed = false;
    _stories = _stories.map((s) {
      if (!s.seen) {
        changed = true;
        return s.copyWith(seen: true);
      }
      return s;
    }).toList();
    if (changed) notifyListeners();
  }

  void addStory() {
    _stories.insert(0, Story(user: _user, createdAt: DateTime.now()));
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Social actions
  // ---------------------------------------------------------------------------
  void toggleFollow(String userId) {
    if (_following.contains(userId)) {
      _following.remove(userId);
    } else {
      _following.add(userId);
    }
    notifyListeners();
  }

  void updateProfile({String? name, String? username, String? bio}) {
    _user = _user.copyWith(name: name, username: username, bio: bio);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Chat actions
  // ---------------------------------------------------------------------------
  void openThread(String threadId) {
    final i = _threads.indexWhere((t) => t.id == threadId);
    if (i == -1) return;
    if (_threads[i].unread == 0) return;
    _threads[i] = _threads[i].copyWith(unread: 0);
    notifyListeners();
  }

  Future<void> sendMessage(String threadId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final i = _threads.indexWhere((t) => t.id == threadId);
    if (i == -1) return;
    final thread = _threads[i];
    final mine = Message(
      id: 'm_${DateTime.now().microsecondsSinceEpoch}',
      text: trimmed,
      isMe: true,
      time: DateTime.now(),
      status: MessageStatus.sent,
    );
    _threads[i] = thread.copyWith(messages: [...thread.messages, mine]);
    notifyListeners();

    // Simulate delivery then a friendly auto-reply.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final j = _threads.indexWhere((t) => t.id == threadId);
    if (j != -1) {
      final msgs = [..._threads[j].messages];
      msgs[msgs.length - 1] = msgs.last.copyWith(status: MessageStatus.read);
      _threads[j] = _threads[j].copyWith(messages: msgs);
      notifyListeners();
    }

    await Future<void>.delayed(const Duration(milliseconds: 900));
    final k = _threads.indexWhere((t) => t.id == threadId);
    if (k != -1) {
      final reply = Message(
        id: 'm_${DateTime.now().microsecondsSinceEpoch}_r',
        text: _autoReply(trimmed),
        isMe: false,
        time: DateTime.now(),
      );
      _threads[k] =
          _threads[k].copyWith(messages: [..._threads[k].messages, reply]);
      notifyListeners();
    }
  }

  String _autoReply(String incoming) {
    const replies = [
      'Haha love that 😄',
      'Say less — I\'m on it!',
      'That\'s a great idea 💡',
      'Let\'s talk more about it later?',
      'You always know what to say 🫶',
      'Bet. Sending it over now.',
    ];
    return replies[incoming.length % replies.length];
  }

  // ---------------------------------------------------------------------------
  // Notification actions
  // ---------------------------------------------------------------------------
  void markAllNotificationsRead() {
    _notifications =
        _notifications.map((n) => n.copyWith(read: true)).toList();
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final i = _notifications.indexWhere((n) => n.id == id);
    if (i == -1) return;
    _notifications[i] = _notifications[i].copyWith(read: true);
    notifyListeners();
  }
}

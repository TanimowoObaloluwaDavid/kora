import 'app_user.dart';

enum NotificationType { like, comment, follow, mention, message }

/// An entry in the activity / notifications list.
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.type,
    required this.user,
    required this.text,
    required this.time,
    this.read = false,
  });

  final String id;
  final NotificationType type;
  final AppUser user;
  final String text;
  final DateTime time;
  final bool read;

  NotificationItem copyWith({bool? read}) => NotificationItem(
        id: id,
        type: type,
        user: user,
        text: text,
        time: time,
        read: read ?? this.read,
      );
}

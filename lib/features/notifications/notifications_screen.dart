import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/formatters.dart';
import '../../data/models/notification_item.dart';
import '../../state/app_state.dart';
import '../../widgets/gradient_avatar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = state.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [
          TextButton(
            onPressed: state.markAllNotificationsRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
        itemBuilder: (context, i) => _NotificationTile(item: items[i]),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final unread = !item.read;
    return ListTile(
      onTap: () => context.read<AppState>().markNotificationRead(item.id),
      tileColor: unread
          ? Theme.of(context).colorScheme.primary.withValues(alpha: .06)
          : null,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          GradientAvatar(user: item.user, size: 48),
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _colorFor(item.type),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: Icon(_iconFor(item.type), size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: item.user.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: ' ${item.text}'),
          ],
        ),
      ),
      subtitle: Text(
        timeAgo(item.time),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .5),
        ),
      ),
      trailing: _trailing(context, item),
    );
  }

  Widget? _trailing(BuildContext context, NotificationItem item) {
    switch (item.type) {
      case NotificationType.like:
        return const Icon(Icons.favorite_rounded, color: Color(0xFFFF5C8A));
      case NotificationType.message:
        return FilledButton.tonal(
          onPressed: () {},
          style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
          child: const Text('Reply'),
        );
      case NotificationType.follow:
        return FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
          child: const Text('Follow'),
        );
      default:
        return null;
    }
  }

  IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite_rounded;
      case NotificationType.comment:
        return Icons.mode_comment_rounded;
      case NotificationType.follow:
        return Icons.person_add_rounded;
      case NotificationType.mention:
        return Icons.alternate_email_rounded;
      case NotificationType.message:
        return Icons.chat_bubble_rounded;
    }
  }

  Color _colorFor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return const Color(0xFFFF5C8A);
      case NotificationType.comment:
        return const Color(0xFF38BDF8);
      case NotificationType.follow:
        return const Color(0xFF6C4DF6);
      case NotificationType.mention:
        return const Color(0xFFFFB020);
      case NotificationType.message:
        return const Color(0xFF2BE0A8);
    }
  }
}

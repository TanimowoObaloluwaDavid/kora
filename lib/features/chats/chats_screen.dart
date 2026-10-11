import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/chat.dart';
import '../../state/app_state.dart';
import '../../widgets/gradient_avatar.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final threads = state.threads.where((t) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return t.peer.name.toLowerCase().contains(q) ||
          t.peer.username.toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) {
        if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
        final at = a.lastMessage?.time ?? DateTime(0);
        final bt = b.lastMessage?.time ?? DateTime(0);
        return bt.compareTo(at);
      });

    final active = state.threads
        .where((t) => t.peer.isOnline)
        .map((t) => t.peer)
        .toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  Text(
                    'Chats',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_square),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Search messages',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            if (active.isNotEmpty) ...[
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: active.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        GradientAvatar(
                          user: active[i],
                          size: 58,
                          showOnline: true,
                          ring: true,
                          ringColor: AppColors.mint,
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 62,
                          child: Text(
                            active[i].username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(height: 24),
            ],
            Expanded(
              child: threads.isEmpty
                  ? const Center(child: Text('No conversations found'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: threads.length,
                      itemBuilder: (context, i) =>
                          _ThreadTile(thread: threads[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({required this.thread});

  final ChatThread thread;

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final last = thread.lastMessage;
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: .55);

    final preview = last == null
        ? 'Say hi 👋'
        : '${last.isMe ? 'You: ' : ''}${last.text}';

    return ListTile(
      onTap: () {
        state.openThread(thread.id);
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ChatScreen(threadId: thread.id),
          ),
        );
      },
      leading: GradientAvatar(
        user: thread.peer,
        size: 52,
        showOnline: true,
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              thread.peer.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          if (thread.peer.isVerified)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.verified_rounded,
                  size: 14, color: AppColors.sky),
            ),
          if (thread.pinned)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.push_pin_rounded, size: 14, color: AppColors.violet),
            ),
        ],
      ),
      subtitle: Text(
        preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: muted, fontWeight: FontWeight.w400),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            last == null ? '' : timeAgo(last.time),
            style: TextStyle(fontSize: 12, color: muted),
          ),
          const SizedBox(height: 6),
          if (thread.unread > 0)
            Container(
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 22),
              decoration: const BoxDecoration(
                gradient: AppColors.brandGradient,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${thread.unread}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

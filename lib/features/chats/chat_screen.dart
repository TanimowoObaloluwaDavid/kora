import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/chat.dart';
import '../../state/app_state.dart';
import '../../widgets/gradient_avatar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.threadId});

  final String threadId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<AppState>().sendMessage(widget.threadId, text);
    _controller.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final thread = state.threadById(widget.threadId);
    if (thread == null) {
      return const Scaffold(body: Center(child: Text('Conversation not found')));
    }
    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            GradientAvatar(
              user: thread.peer,
              size: 40,
              showOnline: true,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  thread.peer.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  thread.peer.isOnline ? 'Active now' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: thread.peer.isOnline
                        ? AppColors.success
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: .5),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: thread.messages.length,
              itemBuilder: (context, i) {
                final message = thread.messages[i];
                final showDay = i == 0 ||
                    thread.messages[i - 1].time.day != message.time.day;
                return Column(
                  children: [
                    if (showDay)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          _dayLabel(message.time),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: .5),
                          ),
                        ),
                      ),
                    _Bubble(message: message),
                  ],
                );
              },
            ),
          ),
          _Composer(controller: _controller, onSend: _send),
        ],
      ),
    );
  }

  String _dayLabel(DateTime time) {
    final now = DateTime.now();
    if (time.year == now.year &&
        time.month == now.month &&
        time.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (time.year == yesterday.year &&
        time.month == yesterday.month &&
        time.day == yesterday.day) {
      return 'Yesterday';
    }
    return '${time.day}/${time.month}/${time.year}';
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isMe ? 20 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 20),
    );

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: isMe ? AppColors.brandGradient : null,
        color: isMe ? null : Theme.of(context).cardColor,
        borderRadius: radius,
        border: isMe
            ? null
            : Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
          height: 1.35,
        ),
      ),
    );

    final meta = Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            clockTime(message.time),
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: .5),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 4),
            _StatusIcon(status: message.status),
          ],
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          bubble,
          meta,
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final MessageStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return const Icon(Icons.schedule_rounded, size: 13, color: Colors.grey);
      case MessageStatus.sent:
        return const Icon(Icons.check_rounded, size: 14, color: AppColors.violet);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all_rounded, size: 14, color: Colors.grey);
      case MessageStatus.read:
        return const Icon(Icons.done_all_rounded, size: 14, color: AppColors.sky);
    }
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Message...',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

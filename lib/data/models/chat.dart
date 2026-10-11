import 'app_user.dart';

enum MessageStatus { sending, sent, delivered, read }

/// A single chat message.
class Message {
  const Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.status = MessageStatus.read,
  });

  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final MessageStatus status;

  Message copyWith({MessageStatus? status}) => Message(
        id: id,
        text: text,
        isMe: isMe,
        time: time,
        status: status ?? this.status,
      );
}

/// A conversation between the current user and a [peer].
class ChatThread {
  const ChatThread({
    required this.id,
    required this.peer,
    required this.messages,
    this.unread = 0,
    this.pinned = false,
  });

  final String id;
  final AppUser peer;
  final List<Message> messages;
  final int unread;
  final bool pinned;

  Message? get lastMessage => messages.isEmpty ? null : messages.last;

  ChatThread copyWith({
    List<Message>? messages,
    int? unread,
    bool? pinned,
  }) {
    return ChatThread(
      id: id,
      peer: peer,
      messages: messages ?? this.messages,
      unread: unread ?? this.unread,
      pinned: pinned ?? this.pinned,
    );
  }
}

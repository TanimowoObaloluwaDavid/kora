import 'models/app_user.dart';
import 'models/chat.dart';
import 'models/notification_item.dart';
import 'models/post.dart';
import 'models/story.dart';

/// In-memory seed data for the Kora demo. No backend required.
class MockData {
  MockData._();

  static final DateTime _now = DateTime.now();

  static const AppUser currentUser = AppUser(
    id: 'me',
    name: 'Ada Okafor',
    username: 'adaokafor',
    bio:
        'Product designer & night-owl 🦉 Building delightful things on the internet.',
    followers: 12400,
    following: 312,
    posts: 148,
    isVerified: true,
    isOnline: true,
  );

  static final List<AppUser> users = [
    const AppUser(
      id: 'u1',
      name: 'Tunde Bakare',
      username: 'tundebk',
      bio: 'Street photographer 📸 | Lagos',
      followers: 28900,
      following: 180,
      posts: 402,
      isVerified: true,
      isOnline: true,
    ),
    const AppUser(
      id: 'u2',
      name: 'Zara Mohammed',
      username: 'zaracodes',
      bio: 'Flutter dev • coffee-powered ☕️',
      followers: 8600,
      following: 420,
      posts: 231,
      isOnline: true,
    ),
    const AppUser(
      id: 'u3',
      name: 'Chidi Nwosu',
      username: 'chidi.builds',
      bio: 'I make food look good 🍜',
      followers: 45300,
      following: 90,
      posts: 512,
      isVerified: true,
    ),
    const AppUser(
      id: 'u4',
      name: 'Amara Eze',
      username: 'amaraeze',
      bio: 'Marathoner 🏃🏾‍♀️ | Plant mom',
      followers: 3300,
      following: 260,
      posts: 88,
      isOnline: true,
    ),
    const AppUser(
      id: 'u5',
      name: 'David Adeyemi',
      username: 'davewave',
      bio: 'Music producer 🎧',
      followers: 67200,
      following: 12,
      posts: 190,
      isVerified: true,
    ),
    const AppUser(
      id: 'u6',
      name: 'Halima Yusuf',
      username: 'halima',
      bio: 'Travel + stories ✈️',
      followers: 15900,
      following: 640,
      posts: 305,
    ),
    const AppUser(
      id: 'u7',
      name: 'Emeka Obi',
      username: 'emeka',
      bio: 'Hoops and good vibes 🏀',
      followers: 5400,
      following: 210,
      posts: 142,
    ),
    const AppUser(
      id: 'u8',
      name: 'Ife Lawson',
      username: 'ifelawson',
      bio: 'Illustrator ✏️',
      followers: 22100,
      following: 330,
      posts: 278,
      isVerified: true,
      isOnline: true,
    ),
  ];

  static List<Post> posts() => [
        Post(
          id: 'p1',
          author: users[0],
          caption:
              'Golden hour downtown never misses. Shot on a 35mm, no filter needed. 🌇',
          tags: ['#photography', '#lagos', '#goldenhour'],
          createdAt: _now.subtract(const Duration(minutes: 24)),
          likes: 1284,
          comments: 76,
          shares: 12,
          liked: true,
          location: 'Victoria Island, Lagos',
        ),
        Post(
          id: 'p2',
          author: users[2],
          caption:
              'Made jollof from scratch today and honestly?? Best batch yet. Who\'s coming over? 🍚🔥',
          tags: ['#foodie', '#jollof'],
          createdAt: _now.subtract(const Duration(hours: 2)),
          likes: 3420,
          comments: 218,
          shares: 88,
          saved: true,
        ),
        Post(
          id: 'p3',
          author: users[4],
          caption:
              'New beat dropping Friday. This one has been living in my head for weeks. 🎶',
          tags: ['#newmusic', '#afrobeats'],
          createdAt: _now.subtract(const Duration(hours: 6)),
          likes: 8910,
          comments: 542,
          shares: 301,
        ),
        Post(
          id: 'p4',
          author: users[1],
          caption:
              'Shipped a new feature at 2am. Deep work hits different when the city is quiet. 💻',
          tags: ['#flutter', '#buildinpublic'],
          createdAt: _now.subtract(const Duration(hours: 11)),
          likes: 640,
          comments: 41,
          shares: 9,
          liked: true,
        ),
        Post(
          id: 'p5',
          author: users[5],
          caption:
              'Sunrise over the dunes. Worth every step of the 4am hike. 🏜️',
          tags: ['#travel', '#sunrise'],
          createdAt: _now.subtract(const Duration(days: 1, hours: 3)),
          likes: 2033,
          comments: 130,
          shares: 54,
        ),
        Post(
          id: 'p6',
          author: users[7],
          caption:
              'Quick character study. Practicing faces with limited palettes — thoughts? ✏️',
          tags: ['#art', '#illustration'],
          createdAt: _now.subtract(const Duration(days: 1, hours: 9)),
          likes: 4770,
          comments: 312,
          shares: 77,
          saved: true,
        ),
        Post(
          id: 'p7',
          author: users[3],
          caption:
              '10km before breakfast. The discipline is the whole point. 🏃🏾‍♀️',
          tags: ['#running', '#fitness'],
          createdAt: _now.subtract(const Duration(days: 2)),
          likes: 918,
          comments: 63,
          shares: 5,
        ),
        Post(
          id: 'p8',
          author: users[6],
          caption: 'Pick-up game at the park. Legs are jelly but the vibes won. 🏀',
          tags: ['#ball', '#weekend'],
          createdAt: _now.subtract(const Duration(days: 3)),
          likes: 512,
          comments: 28,
          shares: 3,
        ),
      ];

  static List<Story> stories() => [
        Story(user: users[1], seen: false, createdAt: _now.subtract(const Duration(hours: 1))),
        Story(user: users[0], seen: false, createdAt: _now.subtract(const Duration(hours: 2))),
        Story(user: users[4], seen: true, createdAt: _now.subtract(const Duration(hours: 5))),
        Story(user: users[2], seen: false, createdAt: _now.subtract(const Duration(hours: 7))),
        Story(user: users[5], seen: true, createdAt: _now.subtract(const Duration(hours: 9))),
        Story(user: users[7], seen: false, createdAt: _now.subtract(const Duration(hours: 11))),
        Story(user: users[3], seen: true, createdAt: _now.subtract(const Duration(hours: 13))),
      ];

  static List<ChatThread> chatThreads() => [
        ChatThread(
          id: 'c1',
          peer: users[1],
          unread: 2,
          pinned: true,
          messages: [
            Message(
              id: 'm1',
              text: 'Hey! Did you see the new design system drop?',
              isMe: false,
              time: _now.subtract(const Duration(minutes: 40)),
            ),
            Message(
              id: 'm2',
              text: 'Just looked — the motion is so smooth 😍',
              isMe: true,
              time: _now.subtract(const Duration(minutes: 38)),
              status: MessageStatus.read,
            ),
            Message(
              id: 'm3',
              text: 'Right?! I\'m stealing the transitions for my app.',
              isMe: false,
              time: _now.subtract(const Duration(minutes: 6)),
            ),
            Message(
              id: 'm4',
              text: 'Send me the file when you\'re done 🙏',
              isMe: false,
              time: _now.subtract(const Duration(minutes: 5)),
            ),
          ],
        ),
        ChatThread(
          id: 'c2',
          peer: users[3],
          unread: 0,
          messages: [
            Message(
              id: 'm5',
              text: 'Morning run tomorrow? 6am?',
              isMe: false,
              time: _now.subtract(const Duration(hours: 3)),
            ),
            Message(
              id: 'm6',
              text: 'I\'m in. Meet at the usual spot.',
              isMe: true,
              time: _now.subtract(const Duration(hours: 2, minutes: 50)),
              status: MessageStatus.read,
            ),
          ],
        ),
        ChatThread(
          id: 'c3',
          peer: users[4],
          unread: 1,
          messages: [
            Message(
              id: 'm7',
              text: 'The mix is done 🔥 check your email',
              isMe: false,
              time: _now.subtract(const Duration(hours: 20)),
            ),
          ],
        ),
        ChatThread(
          id: 'c4',
          peer: users[2],
          unread: 0,
          messages: [
            Message(
              id: 'm8',
              text: 'Recipe is on the blog now 🍲',
              isMe: true,
              time: _now.subtract(const Duration(days: 1, hours: 4)),
              status: MessageStatus.read,
            ),
            Message(
              id: 'm9',
              text: 'You\'re the best, thank you!!',
              isMe: false,
              time: _now.subtract(const Duration(days: 1, hours: 3)),
            ),
          ],
        ),
        ChatThread(
          id: 'c5',
          peer: users[5],
          unread: 0,
          messages: [
            Message(
              id: 'm10',
              text: 'That sunrise spot is unreal. Adding to the list.',
              isMe: true,
              time: _now.subtract(const Duration(days: 2, hours: 5)),
              status: MessageStatus.read,
            ),
          ],
        ),
        ChatThread(
          id: 'c6',
          peer: users[7],
          unread: 0,
          messages: [
            Message(
              id: 'm11',
              text: 'Loved your last illustration 🎨',
              isMe: true,
              time: _now.subtract(const Duration(days: 3)),
              status: MessageStatus.read,
            ),
          ],
        ),
      ];

  static List<NotificationItem> notifications() => [
        NotificationItem(
          id: 'n1',
          type: NotificationType.like,
          user: users[0],
          text: 'liked your post.',
          time: _now.subtract(const Duration(minutes: 3)),
        ),
        NotificationItem(
          id: 'n2',
          type: NotificationType.comment,
          user: users[3],
          text: 'commented: "This is stunning 😍"',
          time: _now.subtract(const Duration(minutes: 18)),
        ),
        NotificationItem(
          id: 'n3',
          type: NotificationType.follow,
          user: users[6],
          text: 'started following you.',
          time: _now.subtract(const Duration(hours: 1)),
          read: true,
        ),
        NotificationItem(
          id: 'n4',
          type: NotificationType.mention,
          user: users[4],
          text: 'mentioned you in a post.',
          time: _now.subtract(const Duration(hours: 4)),
          read: true,
        ),
        NotificationItem(
          id: 'n5',
          type: NotificationType.message,
          user: users[1],
          text: 'sent you a message.',
          time: _now.subtract(const Duration(hours: 6)),
          read: true,
        ),
        NotificationItem(
          id: 'n6',
          type: NotificationType.like,
          user: users[5],
          text: 'and 214 others liked your post.',
          time: _now.subtract(const Duration(days: 1)),
          read: true,
        ),
        NotificationItem(
          id: 'n7',
          type: NotificationType.comment,
          user: users[2],
          text: 'replied to your comment.',
          time: _now.subtract(const Duration(days: 1, hours: 5)),
          read: true,
        ),
        NotificationItem(
          id: 'n8',
          type: NotificationType.follow,
          user: users[7],
          text: 'started following you.',
          time: _now.subtract(const Duration(days: 2)),
          read: true,
        ),
      ];
}

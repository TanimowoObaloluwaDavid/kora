// Smoke tests for the Kora app.

import 'package:flutter_test/flutter_test.dart';

import 'package:kora/app.dart';
import 'package:kora/state/app_state.dart';

void main() {
  testWidgets('Kora boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KoraApp());
    expect(find.text('Kora'), findsWidgets);
    expect(find.text('CONNECT  ·  SHARE  ·  BELONG'), findsOneWidget);
  });

  test('AppState toggles likes and adds posts', () {
    final state = AppState();
    final first = state.posts.first;
    final beforeLikes = first.likes;
    final wasLiked = first.liked;
    state.toggleLike(first.id);
    expect(state.postById(first.id)!.liked, !wasLiked);
    expect(
      state.postById(first.id)!.likes,
      wasLiked ? beforeLikes - 1 : beforeLikes + 1,
    );

    final count = state.posts.length;
    state.addPost(caption: 'Hello Kora', tags: ['#test']);
    expect(state.posts.length, count + 1);
    expect(state.posts.first.caption, 'Hello Kora');
  });

  test('Sending a message appends to the thread', () async {
    final state = AppState();
    final thread = state.threads.first;
    final before = thread.messages.length;
    await state.sendMessage(thread.id, 'Hi there');
    expect(state.threadById(thread.id)!.messages.length, greaterThan(before));
  });
}

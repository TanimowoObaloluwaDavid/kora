import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import '../chats/chats_screen.dart';
import '../feed/feed_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import 'create_post_sheet.dart';

/// Root shell hosting the primary tabs behind a custom bottom bar.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialTab = 0});

  /// Tab shown on first build, allowing deep links such as `/#/chats`.
  final int initialTab;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _index = widget.initialTab.clamp(0, 3);

  final List<Widget> _screens = const [
    FeedScreen(),
    SearchScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  void _openCreate() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreatePostSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: _KoraNavBar(
        index: _index,
        onSelect: (i) => setState(() => _index = i),
        onCreate: _openCreate,
      ),
    );
  }
}

class _KoraNavBar extends StatelessWidget {
  const _KoraNavBar({
    required this.index,
    required this.onSelect,
    required this.onCreate,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<AppState>().unreadChats;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                active: index == 0,
                onTap: () => onSelect(0),
              ),
              _NavItem(
                icon: Icons.search_rounded,
                label: 'Explore',
                active: index == 1,
                onTap: () => onSelect(1),
              ),
              Expanded(
                child: Center(
                  child: _CreateButton(onTap: onCreate),
                ),
              ),
              _NavItem(
                icon: Icons.chat_bubble_rounded,
                label: 'Chats',
                active: index == 2,
                badge: unread,
                onTap: () => onSelect(2),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                active: index == 3,
                onTap: () => onSelect(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.violet
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: .45);
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 26),
                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(minWidth: 16),
                      decoration: const BoxDecoration(
                        gradient: AppColors.brandGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badge',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.violet.withValues(alpha: .4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}

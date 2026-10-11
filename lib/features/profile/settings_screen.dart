import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _GroupLabel('Preferences'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark mode'),
            subtitle: const Text('Switch between light and dark themes'),
            value: theme.isDark,
            onChanged: (_) => theme.toggle(),
          ),
          ListTile(
            leading: const Icon(Icons.text_fields_rounded),
            title: const Text('App font size'),
            subtitle: const Text('Default'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const _GroupLabel('Account'),
          const ListTile(
            leading: Icon(Icons.person_outline_rounded),
            title: Text('Account information'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          const ListTile(
            leading: Icon(Icons.lock_outline_rounded),
            title: Text('Privacy & security'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          const ListTile(
            leading: Icon(Icons.notifications_none_rounded),
            title: Text('Notifications'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          const _GroupLabel('Support'),
          const ListTile(
            leading: Icon(Icons.help_outline_rounded),
            title: Text('Help center'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('About Kora'),
            subtitle: Text('Version 1.0.0'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              ),
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              label: const Text(
                'Log out',
                style: TextStyle(color: Colors.redAccent),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 1,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .5),
        ),
      ),
    );
  }
}

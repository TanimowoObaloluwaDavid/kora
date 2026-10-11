import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/shell/app_shell.dart';
import 'features/splash/splash_screen.dart';
import 'state/app_state.dart';
import 'state/theme_controller.dart';

class KoraApp extends StatelessWidget {
  const KoraApp({super.key});

  /// Resolves the first route from the browser URL on web so that links such
  /// as `/#/chats` open the app directly on a given tab. Native falls back to
  /// the splash route.
  static String _initialRoute() {
    if (!kIsWeb) return '/';
    final fragment = Uri.base.fragment;
    if (fragment.startsWith('/')) return fragment;
    final path = Uri.base.path;
    if (path.isNotEmpty && path != '/') return path;
    return '/';
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Kora',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: theme.mode,
            initialRoute: _initialRoute(),
            routes: {
              '/': (_) => const SplashScreen(),
              '/onboarding': (_) => const OnboardingScreen(),
              '/login': (_) => const LoginScreen(),
              '/signup': (_) => const SignupScreen(),
              '/home': (_) => const AppShell(),
              '/feed': (_) => const AppShell(initialTab: 0),
              '/explore': (_) => const AppShell(initialTab: 1),
              '/chats': (_) => const AppShell(initialTab: 2),
              '/profile': (_) => const AppShell(initialTab: 3),
            },
          );
        },
      ),
    );
  }
}

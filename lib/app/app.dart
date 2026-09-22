import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_strings.dart';
import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import 'navigation/app_shell.dart';
import 'splash_screen.dart';
import 'theme/app_theme.dart';

/// Root widget: owns the splash -> login -> [AppShell] navigation flow
/// based on [AuthState]. [AppShell] is the single source of truth for
/// in-app navigation (drawer/sidebar + per-destination back-stacks) —
/// see `app/navigation/`.
class SkmEggApp extends ConsumerStatefulWidget {
  const SkmEggApp({super.key});

  @override
  ConsumerState<SkmEggApp> createState() => _SkmEggAppState();
}

class _SkmEggAppState extends ConsumerState<SkmEggApp> {
  bool _splashDone = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _RootTransitionSwitcher(child: _resolveHome(authState)),
    );
  }

  Widget _resolveHome(AuthState authState) {
    if (!_splashDone) {
      return SplashScreen(
        key: const ValueKey('splash'),
        onFinished: () => setState(() => _splashDone = true),
      );
    }

    if (authState.isSignedIn) {
      return AppShell(
        key: const ValueKey('shell'),
        userName: authState.userDisplayName ?? 'User',
        onLogout: () => ref.read(authControllerProvider.notifier).signOut(),
      );
    }

    return const LoginScreen(key: ValueKey('login'));
  }
}

/// Animates the splash -> login -> shell swap at the [MaterialApp.home]
/// level with a native-feeling cross-fade + slight rise, instead of an
/// instant widget-tree cut (the default when swapping `home:` directly).
class _RootTransitionSwitcher extends StatelessWidget {
  const _RootTransitionSwitcher({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

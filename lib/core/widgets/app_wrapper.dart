import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/navigation_service.dart';
import '../../features/splash/presentation/splash_screen.dart';

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({super.key});

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    // Wait a bit for providers to initialize
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      final route = await NavigationService.getInitialRoute(ref);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen while determining initial route
    return const SplashScreen();
  }
}

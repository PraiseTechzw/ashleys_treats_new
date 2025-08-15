import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>(
  (ref) => OnboardingNotifier(),
);

final onboardingNotifierProvider = Provider<OnboardingNotifier>((ref) {
  return ref.read(onboardingProvider.notifier);
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      print('Onboarding provider: Loading status from SharedPreferences: $hasSeenOnboarding'); // Debug info
      
      if (mounted) {
        state = hasSeenOnboarding;
        print('Onboarding provider: State updated to: $state'); // Debug info
      }
    } catch (e) {
      print('Onboarding provider: Error loading status: $e'); // Debug info
      if (mounted) {
        state = false; // Default to false on error
      }
    }
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    state = true;
    print('Onboarding marked as complete'); // Debug info
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', false);
    state = false;
    print('Onboarding reset'); // Debug info
  }
}

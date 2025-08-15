import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/splash/presentation/providers/onboarding_provider.dart';

class DebugOnboardingStatus extends ConsumerWidget {
  const DebugOnboardingStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingStatus = ref.watch(onboardingProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔍 DEBUG: Onboarding Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text('hasSeenOnboarding: $onboardingStatus'),
          Text('Type: ${onboardingStatus.runtimeType}'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final notifier = ref.read(onboardingProvider.notifier);
              await notifier.resetOnboarding();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Onboarding reset!')),
              );
            },
            child: const Text('Reset Onboarding'),
          ),
          ElevatedButton(
            onPressed: () async {
              final notifier = ref.read(onboardingProvider.notifier);
              await notifier.markOnboardingComplete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Onboarding marked complete!')),
              );
            },
            child: const Text('Mark Complete'),
          ),
        ],
      ),
    );
  }
}

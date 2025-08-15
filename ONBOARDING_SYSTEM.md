# Onboarding System Documentation

## Overview
The onboarding system in Ashley's Treats app ensures that first-time users see a welcome experience while returning users skip directly to the main app.

## How It Works

### 1. First Launch
- When a user first opens the app, they see the splash screen
- The app checks if onboarding has been completed (stored in SharedPreferences)
- Since it's the first time, `hasSeenOnboarding` is `false`
- User is redirected to the onboarding screen

### 2. Onboarding Experience
- Users see 4 beautiful onboarding slides with animations:
  1. Welcome to Ashley's Treats
  2. Browse & Choose
  3. Order & Enjoy
  4. Track & Celebrate
- Users can navigate between slides or skip the entire experience
- Each slide has a Lottie animation and descriptive text

### 3. Completion
- When users complete onboarding (either by going through all slides or skipping)
- `hasSeenOnboarding` is set to `true` in SharedPreferences
- User is redirected to the appropriate screen based on authentication status

### 4. Subsequent Launches
- On subsequent app launches, `hasSeenOnboarding` is `true`
- Users skip the onboarding and go directly to login/auth screens
- The onboarding experience is never shown again unless manually reset

## Technical Implementation

### Files Involved
- `lib/features/splash/presentation/onboarding_screen.dart` - The onboarding UI
- `lib/features/splash/presentation/providers/onboarding_provider.dart` - State management
- `lib/core/services/navigation_service.dart` - Navigation logic
- `lib/core/widgets/app_wrapper.dart` - App initialization wrapper

### Key Components

#### OnboardingProvider
```dart
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>(
  (ref) => OnboardingNotifier(),
);
```

#### Navigation Logic
```dart
static Future<String> getInitialRoute(WidgetRef ref) async {
  final hasSeenOnboarding = ref.read(onboardingProvider);
  
  if (!hasSeenOnboarding) {
    return '/onboarding';
  }
  
  final authState = ref.read(authProvider);
  if (authState.isAuthenticated) {
    return '/auth';
  } else {
    return '/login';
  }
}
```

### Data Persistence
- Uses `SharedPreferences` to store `hasSeenOnboarding` boolean
- Key: `'hasSeenOnboarding'`
- Value: `true` (completed) or `false` (not completed)

## User Experience Features

### 1. Skip Option
- Users can skip onboarding at any time
- A "Skip" button is always visible at the top right

### 2. Navigation Controls
- Previous/Next buttons for slide navigation
- Page indicators showing current position
- Smooth animations between slides

### 3. Completion Feedback
- Success message when onboarding is completed
- Smooth transition to the next screen

### 4. Reset Option
- Users can reset onboarding from the profile screen
- Option: "Show Onboarding Again" in Support section
- Useful for demo purposes or if users want to see it again

## Testing the System

### To Test First-Time Experience
1. Clear app data or uninstall/reinstall
2. Launch the app
3. You should see the onboarding screens

### To Test Returning User Experience
1. Complete onboarding once
2. Restart the app
3. You should skip onboarding and go to login/auth

### To Reset Onboarding
1. Complete onboarding and log in
2. Go to Profile → Support → "Show Onboarding Again"
3. Confirm the reset
4. Restart the app to see onboarding again

## Customization

### Adding New Slides
Edit the `_slides` list in `onboarding_screen.dart`:
```dart
final List<Map<String, dynamic>> _slides = [
  {
    'title': 'Your Title',
    'subtitle': 'Your Subtitle',
    'desc': 'Your description',
    'animation': 'path/to/animation.json',
    'color': AppColors.yourColor,
  },
  // Add more slides...
];
```

### Changing Default Country
The phone input defaults to Zimbabwe (+263). To change this:
1. Update `_selectedCountryCode` in `register_screen.dart`
2. Update the `initialValue` in the `InternationalPhoneNumberInput`

## Troubleshooting

### Common Issues
1. **Onboarding shows every time**: Check if SharedPreferences is working correctly
2. **Navigation loops**: Ensure proper route handling in navigation service
3. **State not persisting**: Verify SharedPreferences initialization

### Debug Information
The system includes debug prints to help troubleshoot:
- Onboarding status loading
- Navigation routing decisions
- State changes

## Future Enhancements
- A/B testing for different onboarding flows
- Analytics tracking for onboarding completion rates
- Personalized onboarding based on user preferences
- Multi-language support for onboarding content

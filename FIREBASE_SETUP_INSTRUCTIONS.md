# Firebase Setup Instructions for Ashley's Treats App

## Prerequisites
- A Google account
- Flutter project with Firebase packages already added to `pubspec.yaml`

## Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or select an existing project
3. Enter a project name (e.g., "ashleys-treats")
4. Follow the setup wizard (you can disable Google Analytics if not needed)

## Step 2: Add Android App
1. In your Firebase project, click the Android icon (+ Add app)
2. Enter package name: `com.appixia.ashleys_treats_new`
3. Enter app nickname: "Ashley's Treats"
4. Click "Register app"

## Step 3: Download Configuration File
1. Download the `google-services.json` file
2. Place it in `android/app/google-services.json`
3. **Important**: Replace the placeholder file with the actual downloaded file

## Step 4: Enable Firestore Database
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location close to your users
5. Click "Done"

## Step 5: Set Up Security Rules (Optional)
In Firestore Database > Rules, you can set up security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // For development only
    }
  }
}
```

**Note**: The above rule allows all access. For production, implement proper authentication and authorization.

## Step 6: Test the Setup
1. Run `flutter clean`
2. Run `flutter pub get`
3. Try building the app: `flutter build apk --debug`

## Troubleshooting

### Build Errors
- Make sure `google-services.json` is in the correct location
- Verify all Firebase dependencies are added to `pubspec.yaml`
- Check that Android Gradle Plugin version is compatible

### Runtime Errors
- Ensure Firestore Database is created and accessible
- Check internet connectivity
- Verify Firebase project is active

## Next Steps
Once Firebase is set up:
1. The app will automatically connect to Firestore
2. Use the "Seed Demo Data" button in the admin panel to populate sample products
3. Products will be stored in the `products` collection in Firestore

## Support
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Firebase Documentation](https://firebase.flutter.dev/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)

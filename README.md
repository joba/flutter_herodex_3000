# Flutter Herodex 3000

A Flutter application for browsing and managing superhero information using the SuperheroAPI. The app supports multiple platforms (iOS, Android, Web, macOS) and provides features like hero search, roster management, location-based features, and user authentication.

## Features

- **Hero Search**: Search for superheroes from the SuperheroAPI database
- **Hero Details**: View detailed information about each superhero including stats, biography, and appearance
- **Roster Management**: Create and manage your own roster of favorite heroes
- **User Authentication**: Firebase authentication for user accounts
- **Theme Support**: Light and dark theme switching
- **Location Services**: Geolocation features for location-based functionality
- **Cross-Platform**: Runs on iOS, Android, Web, macOS, Linux, and Windows
- **Analytics & Crashlytics**: Firebase Analytics and Crashlytics integration

## Prerequisites

- Flutter SDK (^3.10.1)
- Dart SDK (^3.10.1)
- Firebase account and project setup
- SuperheroAPI key (get one from [superheroapi.com](https://superheroapi.com))
- Node.js and npm (for web proxy server)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/joba/flutter_herodex_3000.git
cd flutter_herodex_3000
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Create a `.env` file in the root directory:

```env
SUPERHERO_API_KEY=your_superhero_api_key_here
```

### 4. Firebase Setup

Ensure Firebase is properly configured for your target platforms:

- The `firebase_options.dart` file should be generated using FlutterFire CLI
- Add `google-services.json` for Android (already included in `android/app/`)
- Add `GoogleService-Info.plist` for iOS

### 5. Running the App

#### Mobile & Desktop

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# macOS
flutter run -d macos
```

#### Web

**Important**: When running on web, you must start the proxy server first to bypass CORS restrictions:

1. Navigate to the proxy server directory:

```bash
cd proxy-server
```

2. Install dependencies (first time only):

```bash
npm install
```

3. Set your API key:

```bash
export SUPERHERO_API_KEY=your_superhero_api_key_here
```

4. Start the proxy server:

```bash
npm start
```

The proxy server will run on `http://localhost:3000`

5. In a new terminal, run the Flutter web app:

```bash
flutter run -d chrome
```

## Project Structure

```
flutter_herodex_3000/
├── lib/
│   ├── auth/                         # Authentication logic
│   │   ├── cubit/                    # Auth state management
│   │   └── repository/               # Auth repository
│   ├── blocs/                        # BLoC state management
│   │   ├── hero_detail/              # Hero detail BLoC
│   │   ├── roster/                   # Roster management BLoC
│   │   └── theme/                    # Theme management Cubit
│   ├── config/                       # App configuration
│   │   ├── app_router.dart           # GoRouter navigation config
│   │   └── app_texts.dart            # Texts for the app
│   ├── data/                         # Data models and sources
│   ├── managers/                     # Manager classes
│   │   ├── analytics_manager.dart    # Firebase Analytics
│   │   ├── api_manager.dart          # API communication
│   │   ├── crashlytics_manager.dart  # Crash reporting
│   │   ├── image_manager.dart        # Local image handling
│   │   ├── location_manager.dart     # Location services
│   │   └── network_manager.dart      # Connection services
│   ├── models/                       # Data models
│   ├── screens/                      # UI screens
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── onboarding_screen.dart
│   │   ├── roster_screen.dart
│   │   ├── search_screen.dart
│   │   ├── settings_screen.dart
│   │   └── splash_screen.dart
│   ├── styles/                       # Theme and styling
│   │   ├── colors.dart
│   │   └── themes.dart
│   ├── utils/                        # Utility functions
│   │   ├── constants.dart
│   │   ├── decorations.dart
│   │   ├── snackbar.dart
│   │   └── logger.dart
│   ├── widgets/                      # Reusable widgets
│   ├── firebase_options.dart         # Firebase configuration
│   └── main.dart                     # App entry point
├── assets/                           # Static assets
├── proxy-server/                     # CORS proxy for web
│   ├── server.js
│   ├── package.json
│   └── README.md
├── test/                             # Tests
├── android/                          # Android platform files
├── ios/                              # iOS platform files
├── web/                              # Web platform files
├── macos/                            # macOS platform files
├── linux/                            # Linux platform files
├── windows/                          # Windows platform files
├── pubspec.yaml                      # Dependencies
├── analysis_options.yaml             # Linter configuration
└── README.md
```

## Configuration Files

### `pubspec.yaml`

Main dependency configuration file. Key dependencies include:

- **State Management**: `flutter_bloc`, `bloc`, `equatable`
- **Firebase**: `firebase_core`, `firebase_auth`, `firebase_analytics`, `firebase_crashlytics`, `cloud_firestore`
- **Navigation**: `go_router`
- **UI**: `flutter_svg`, `google_fonts`, `flutter_map`
- **Storage**: `shared_preferences`, `path_provider`
- **HTTP**: `http`
- **Location**: `geolocator`, `latlong2`
- **Device Info**: `package_info_plus`, `device_info_plus`
- **Environment**: `flutter_dotenv`
- **Connectivity**: `connectivity_plus`

### `analysis_options.yaml`

Dart analyzer configuration with lint rules.

### `firebase.json`

Firebase hosting and services configuration.

### `.env`

Environment variables (not committed to git):

- `SUPERHERO_API_KEY`: Your SuperheroAPI key

## Testing

Run tests using:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

The `test/` directory contains widget tests and unit tests.

## Building for Production

### Android

```bash
flutter build apk --release        # Build APK
flutter build appbundle --release  # Build App Bundle for Play Store
```

### iOS

```bash
flutter build ios --release
```

### Web

1. Ensure proxy server is deployed to a production server
2. Update the `_corsProxy` URL in `lib/managers/api_manager.dart`
3. Build the web app:

```bash
flutter build web --release
```

### Desktop

```bash
flutter build macos --release
```

## Proxy Server Deployment

The proxy server can be deployed to various platforms:

### Vercel

```bash
cd proxy-server
vercel deploy
```

### Heroku

```bash
cd proxy-server
git push heroku main
```

### Railway

Connect your repository to Railway and deploy.

After deployment, update the `_corsProxy` variable in `lib/managers/api_manager.dart` with your deployed URL.

## Key Features Implementation

### State Management

The app uses BLoC pattern for state management:

- `AuthCubit`: Manages authentication state
- `ThemeCubit`: Manages theme switching
- `RosterBloc`: Manages hero roster
- `HeroDetailBloc`: Manages hero detail views

### Navigation

GoRouter is used for declarative routing with:

- Splash screen on app launch
- Onboarding flow for first-time users
- Protected routes requiring authentication
- Deep linking support

### Firebase Integration

- **Authentication**: User sign-in/sign-up
- **Firestore**: Data storage for user rosters
- **Analytics**: User behavior tracking
- **Crashlytics**: Error and crash reporting

## Troubleshooting

### Web CORS Issues

If you encounter CORS errors on web:

1. Ensure the proxy server is running (`cd proxy-server && npm start`)
2. Check that the proxy URL in `api_manager.dart` matches your running proxy
3. Verify your SuperheroAPI key is set in the environment

### Firebase Issues

If Firebase initialization fails:

1. Verify `firebase_options.dart` is properly configured
2. Check platform-specific configuration files (google-services.json, GoogleService-Info.plist)
3. Ensure Firebase project is set up correctly in the Firebase Console

### Build Issues

If you encounter build issues:

1. Clean the build: `flutter clean`
2. Get dependencies: `flutter pub get`
3. For iOS: `cd ios && pod install && cd ..`
4. For macOS: `cd macos && pod install && cd ..`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## License

This project is private and not published to pub.dev.

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [SuperheroAPI Documentation](https://superheroapi.com/index.html)
- [Firebase Documentation](https://firebase.google.com/docs)
- [BLoC Library](https://bloclibrary.dev/)

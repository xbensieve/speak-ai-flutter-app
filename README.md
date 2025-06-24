# Echo Nexus – English App with AI

Echo Nexus is a Flutter application designed to help users improve their English skills using modern UI, AI-powered features, and seamless user experience.

## Features

- **User Authentication**: Secure login with token storage ([`LoginViewModel`](lib/view_models/login_view_model.dart)).
- **Home, Learn, AI Tutor, Profile**: Modular navigation with bottom navigation bar ([`NavigationMenu`](lib/components/navigation_menu.dart)).
- **Profile Management**: Logout, upgrade account, and test payment integration ([`ProfileScreen`](lib/pages/profile_screen.dart)).
- **Modern UI**: Custom splash screen, animated transitions, and Google Fonts.
- **State Management**: Uses [GetX](https://pub.dev/packages/get) for efficient state and navigation.
- **Persistent Storage**: Uses [get_storage](https://pub.dev/packages/get_storage) for local data.
- **API Integration**: Connects to backend for authentication ([`ApiService`](lib/services/implement/api_service.dart)).
- **Extensible**: Easily add new screens and features.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart 3.7.2 or higher
- Android Studio or Xcode for mobile development

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/xbensieve/speak-ai-flutter-app.git
   cd speak-ai-flutter-app
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

### Project Structure

- `lib/`
  - `main.dart` – App entry point
  - `components/` – Reusable UI widgets
  - `pages/` – Main screens (Home, Learn, Tutor, Profile, Splash, Login)
  - `view_models/` – State management logic
  - `models/` – Data models for API requests/responses
  - `services/` – API service layer
  - `config/` – API configuration

- `android/`, `ios/` – Platform-specific code and assets

### Configuration

- API endpoints are set in [`ApiConfig`](lib/config/api_configuration.dart).
- Assets are located in `lib/assets/images/`.

### Running Tests

Run widget tests with:
```sh
flutter test
```

### Dependencies

See [`pubspec.yaml`](pubspec.yaml) for the full list. Key packages:
- `get`, `get_storage`, `http`, `google_fonts`, `flutter_tts`, `speech_to_text`, `url_launcher`, `cached_network_image`, `percent_indicator`, `animate_do`, `flutter_secure_storage`, `jwt_decoder`

## Contributing

Pull requests are welcome. For major changes, please open an issue first.

## License

This project is private and not published to pub.dev.

---

**Note:** This app is a starting point and can be extended with more features such as AI-powered learning, quizzes, and more.

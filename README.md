# DriveHub

DriveHub is a Flutter app prototype for a premium car agency. Customers can explore cars, view car details, save favorites, and browse service booking options. An admin area provides a dashboard, customer list, and a form for entering car details.

> **Project status:** This is a UI prototype. Screens use local mock data; there is no connected API, database, real login, or persistent booking flow.

## Contents

- [Highlights](#highlights)
- [Technology](#technology)
- [Get started](#get-started)
- [Demo access](#demo-access)
- [Project structure](#project-structure)
- [How the app is organized](#how-the-app-is-organized)
- [Assets](#assets)
- [Known prototype limitations](#known-prototype-limitations)

## Highlights

- Splash, onboarding, login, registration, and forgot-password screens
- Customer home page with car categories, featured cars, brands, and recommendations
- Car search, filters, sorting, listing cards, and detail screens
- In-memory wishlist shared by favorite buttons
- Service booking UI with service, date, and time selection
- Admin dashboard with summary cards, a revenue illustration, and recent orders
- Customer list and add-car form UI
- Reusable components for buttons, fields, cards, images, and bottom navigation
- Local car, brand, and avatar image assets with image fallbacks

## Technology

- Flutter and Dart
- Material 3 (`ThemeData(useMaterial3: true)`)
- Flutter SDK widgets and libraries; no third-party runtime package is required by the app
- `flutter_test` and `flutter_lints` are included as development dependencies

## Get started

### Requirements

- Flutter SDK installed and available on your `PATH`
- An emulator, simulator, or connected device

### Run the app

Run these commands from the directory that contains this README and `pubspec.yaml`:

```sh
flutter pub get
flutter run
```

The Android project files are in `android/`. To run on another platform, that platform's Flutter project files and development setup must also be available.

## Demo access

The login screen is not connected to an authentication service. Enter any email and password to continue. An email beginning with `admin` (case-insensitive) opens the admin area; other emails open the customer area. The **Continue as Admin** button opens the admin area directly.

This routing is only for demonstrating the screens. It must not be used as real access control.

## Project structure

```text
lib/
  main.dart                  App entry point and MaterialApp configuration
  core/
    app_colors.dart          Shared colors and shadows
    app_theme.dart           App-wide Material theme
    formatters.dart          Price and date formatting helpers
    navigation.dart          Shared screen navigation helpers
  data/
    models.dart              Car, customer, service, order, and category models
    mock_data.dart           Demo content used by screens
    car_filter.dart          Car filter and sort types and matching logic
    wishlist_store.dart      Shared in-memory wishlist state
  screens/
    auth/                    Splash, onboarding, and account screens
    user/                    Customer screens and navigation shell
    admin/                   Admin screens and navigation shell
  widgets/                   Reusable UI components
assets/
  cars/                      Car photos
  brands/                    Brand logos
  avatars/                   Profile and customer images
android/                     Android app and Gradle configuration
test/                        Flutter widget tests
pubspec.yaml                 Package metadata, dependencies, and asset declarations
analysis_options.yaml        Dart analyzer and lint configuration
```

## How the app is organized

- `main.dart` calls `runApp` and configures the app theme, title, text scaling, and initial splash screen.
- The auth flow begins at `SplashScreen`, then moves to onboarding and login.
- `UserShell` and `AdminShell` provide bottom navigation. Each uses an `IndexedStack` to keep tab screens in the widget tree while switching tabs.
- Screen navigation helpers in `core/navigation.dart` use Flutter's `Navigator` and `MaterialPageRoute`.
- Screen content is built from reusable widgets in `widgets/` and typed demo content from `data/`.
- Stateful screens use `setState` for local UI changes. The wishlist uses a `ValueNotifier` so favorite buttons can update when the shared list changes.

## Assets

Image paths are declared in `pubspec.yaml` under `assets/cars/`, `assets/avatars/`, and `assets/brands/`. Keep those folders and file names when replacing images. `CarImage` and avatar widgets provide placeholders when an image path is missing or cannot be loaded.

The theme refers to Poppins and Inter font names in some widgets, but the font files are not currently bundled; Flutter falls back to the platform font. To use the intended fonts, add their files under `assets/fonts/` and declare them in `pubspec.yaml`.

## Known prototype limitations

- Car, customer, order, service, and dashboard values come from `MockData` rather than a server.
- Login and admin selection are not authentication or authorization.
- Wishlist changes exist only in memory and reset when the app process restarts.
- Booking screens demonstrate UI interactions but do not submit bookings to a service.
- The add-car form validates a small amount of input and displays a confirmation message; it does not save a car. Image upload is not wired to an image picker.
- Some admin tabs are placeholders because their screens are not implemented.
- The `colorIndex` and `seats` filter options are represented in the filter model, but mock car records do not include corresponding fields for filtering.

## Tests

Widget tests are located in `test/widget_test.dart`. To run them:

```sh
flutter test
```

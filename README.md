# DriveHub – Flutter UI (from Figma screenshots)

16 screens, UI only (mock data, no backend). Flutter + Dart, no third-party packages.

## Run it
```bash
cd drivehub
flutter create . --platforms=android,ios   # generates android/ios folders, keeps lib/ and pubspec.yaml
flutter pub get
flutter run
```
Log in with any email/password. An email that starts with `admin` opens the admin screens.

## Folder layout
```
lib/
  core/      colors, theme, formatters, navigation helpers
  data/      models, mock data, wishlist store, filter model
  widgets/   reusable widgets (buttons, fields, nav bar, cards, car image)
  screens/
    auth/    splash, onboarding, login, register
    user/    shell, home, browse, listings, filter, details, booking, wishlist, service, profile
    admin/   shell, dashboard, customers, add car
```

## Assets
All images in `assets/` were cropped from your Figma PNGs (cars, avatars, brand logos). Replace them with your original exports whenever you have them (same file names). Missing files fall back to a placeholder instead of crashing.

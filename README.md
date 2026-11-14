# DriveHub – Car Agency (Flutter + Firebase)

Fully working car dealership app: customers browse cars, wishlist them, book test drives and services; admins manage cars, bookings and customers.

## 1. Firebase setup (required)

1. Create a **Firebase project**, enable *Email/Password* in Authentication, and create a *Cloud Firestore* database.
2. Run `flutterfire configure` from the project folder to generate `lib/firebase_options.dart`.
   Android Firebase options are already present; rerun this only when changing Firebase projects.
3. In Firestore → **Rules**, publish the contents of `firestore.rules`.
4. Run `flutter pub get`, then `flutter run`.

`firebase.json` points to `firestore.rules`. To publish the rules with Firebase CLI,
sign in with `firebase login`, then run:

```sh
firebase deploy --only firestore:rules --project YOUR_FIREBASE_PROJECT_ID
```

Replace `YOUR_FIREBASE_PROJECT_ID` with the project ID shown in Firebase Console,
without angle brackets. Use the same Firebase project configured in
`lib/firebase_options.dart`. Firestore access requires sign-in, and only an
account with `users/{uid}.role` set to `admin` can add, edit, or seed cars. After
changing a role in Firebase Console, sign out and back in. Do not use public
read/write rules.

## 2. Creating an admin account

1. Register a regular account in the app.
2. In Firebase Console → Firestore → `users`, open your user document and change
   the `role` field from `user` to **`admin`**.
3. Sign out and back in to open the Admin dashboard.

## 3. Adding cars

In Admin → **Cars**, select **Load 15 sample cars** if the list is empty, or
select **Add** to create a car with up to three photos. Photos are stored in
Firestore; Firebase Storage is not required.

## Firestore collections

| Collection | Purpose |
|---|---|
| `users/{uid}` | Name, phone, email, photo, and role (`user`/`admin`) |
| `users/{uid}/wishlist/{carId}` | The user's wishlist |
| `cars/{id}` | Cars and their prices in INR |
| `cars/{id}/ratings/{uid}` | A signed-in user's 1–5 star rating; users can update their own rating |
| `bookings/{id}` | Test-drive bookings (Pending → Confirmed → Completed / Cancelled) |
| `serviceBookings/{id}` | Service bookings (same status flow) |

## Features

**User:** Sign in/register, password reset, auto sign-in, home (featured cars,
brands, categories, search), browse/filter/sort cars, car details (gallery,
wishlist, sharing, 1–5 star ratings), test-drive booking, service booking, My
Bookings (cancel), notifications, profile editing, settings, and sign out.

**Admin:** Live dashboard (cars/bookings/customers/revenue), add/edit/delete
cars, update booking statuses, view customers, and sign out.

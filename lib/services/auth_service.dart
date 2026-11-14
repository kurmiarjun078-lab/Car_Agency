import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/car_store.dart';
import '../data/profile_store.dart';
import '../data/wishlist_store.dart';

/// Handles all Firebase Auth and Firestore operations.
class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// Call once after Firebase.initializeApp: starts/stops the live data
  /// (cars, wishlist, profile) whenever the user logs in or out.
  void init() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        CarStore.stop();
        WishlistStore.stop();
        ProfileStore.stop();
      } else {
        CarStore.start();
        WishlistStore.start(user.uid);
        ProfileStore.start(user.uid);
      }
    });
  }

  /// Registers a user and saves their profile to Firestore at `users/{uid}`.
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(name.trim());
    await _db.collection('users').doc(cred.user!.uid).set({
      'name': name.trim(),
      'phone': phone.trim(),
      'email': email.trim().toLowerCase(),
      'photo': '',
      'role': 'user', // Set to 'admin' in Firebase Console to grant admin access.
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Signs in and returns the role: 'admin' or 'user'.
  Future<String> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final ref = _db.collection('users').doc(cred.user!.uid);
    final doc = await ref.get();
    if (!doc.exists) {
      // Account made from the Firebase console: create its profile now.
      await ref.set({
        'name': cred.user!.displayName ?? '',
        'phone': '',
        'email': (cred.user!.email ?? email).toLowerCase(),
        'photo': '',
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return 'user';
    }
    return (doc.data()?['role'] as String?) ?? 'user';
  }

  /// Role of the already signed-in user ('admin' or 'user').
  Future<String> currentRole() async {
    final user = _auth.currentUser;
    if (user == null) return 'user';
    final doc = await _db.collection('users').doc(user.uid).get();
    return (doc.data()?['role'] as String?) ?? 'user';
  }

  /// Saves the name, phone, and photo in Firestore and the Auth display name.
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String? photo,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.updateDisplayName(name.trim());
    await _db.collection('users').doc(user.uid).update({
      'name': name.trim(),
      'phone': phone.trim(),
      'photo': photo ?? '',
    });
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> logout() => _auth.signOut();

  /// Email of the signed-in user (empty if nobody is signed in).
  String get email => _auth.currentUser?.email ?? '';

  /// Converts FirebaseAuthException codes into readable messages.
  static String friendlyError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'The email or password is incorrect.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'network-request-failed':
          return 'Check your internet connection.';
        case 'too-many-requests':
          return 'Too many attempts. Try again later.';
      }
      return e.message ?? 'Auth error: ${e.code}';
    }
    return 'Something went wrong: $e';
  }
}

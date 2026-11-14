import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../data/app_data.dart';
import '../data/profile_store.dart';
import '../services/auth_service.dart';
import 'car_image.dart';

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

/// Edit profile photo, name, and phone. Email is shown but not editable.
Future<void> showEditProfileDialog(BuildContext context) async {
  final profile = ProfileStore.user.value;
  final auth = AuthService.instance;
  final name = TextEditingController(
    text: (profile?.name.isNotEmpty ?? false)
        ? profile!.name
        : (auth.currentUser?.displayName ?? ''),
  );
  final phone = TextEditingController(text: profile?.phone ?? '');
  String? photo = (profile?.photo.isNotEmpty ?? false) ? profile!.photo : null;
  var saving = false;
  String? error;

  await showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Personal details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Avatar(size: 64, name: name.text, photo: photo),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton.icon(
                    onPressed: saving
                        ? null
                        : () async {
                            try {
                              final picked = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                                maxWidth: 512,
                                maxHeight: 512,
                                imageQuality: 70,
                              );
                              if (picked == null) return;
                              final encoded =
                                  base64Encode(await picked.readAsBytes());
                              if (!ctx.mounted) return;
                              if (encoded.length > 400000) {
                                setState(() => error =
                                    'Photo is too large. Choose a smaller image.');
                                return;
                              }
                              setState(() {
                                photo = encoded;
                                error = null;
                              });
                            } catch (e) {
                              if (ctx.mounted) {
                                setState(
                                    () => error = 'Could not select photo: $e');
                              }
                            }
                          },
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(photo == null ? 'Add photo' : 'Change photo'),
                  ),
                ),
                if (photo != null)
                  IconButton(
                    onPressed: saving
                        ? null
                        : () => setState(() {
                              photo = null;
                              error = null;
                            }),
                    tooltip: 'Remove photo',
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            TextField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email: ${auth.email}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: saving ? null : () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: saving
                ? null
                : () async {
                    if (name.text.trim().isEmpty) {
                      setState(() => error = 'Name is required');
                      return;
                    }
                    setState(() {
                      saving = true;
                      error = null;
                    });
                    try {
                      await auth.updateProfile(
                        name: name.text,
                        phone: phone.text,
                        photo: photo,
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (context.mounted) _snack(context, 'Profile updated.');
                    } catch (e) {
                      setState(() {
                        saving = false;
                        error = 'Could not save changes: $e';
                      });
                    }
                  },
            child: Text(saving ? 'Saving...' : 'Save'),
          ),
        ],
      ),
    ),
  );
  name.dispose();
  phone.dispose();
}

/// Security: sends a password-reset email to the signed-in account.
Future<void> showSecurityDialog(BuildContext context) async {
  final email = AuthService.instance.email;
  final send = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Change password'),
      content: Text('A password reset link will be sent to $email.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Send link'),
        ),
      ],
    ),
  );
  if (send != true || email.isEmpty) return;
  try {
    await AuthService.instance.sendPasswordReset(email);
    if (context.mounted) _snack(context, 'Password reset link sent to $email.');
  } catch (e) {
    if (context.mounted) _snack(context, 'Could not send the link: $e');
  }
}

Future<void> showHelpCenter(BuildContext context) {
  const faqs = <(String, String)>[
    (
      'How do I book a test drive?',
      'Open a car from Cars, tap "Book Test Drive", choose a date and time, then confirm.'
    ),
    (
      'Where can I see my booking status?',
      'Check the Bookings tab. The dealer will update the status to "Confirmed".'
    ),
    (
      'How do I cancel a booking?',
      'In the Bookings tab, tap "Cancel booking" below a pending or confirmed booking.'
    ),
    (
      'How do I book a service?',
      'In the Bookings tab, tap "Book a Service", then choose a service, date, and time.'
    ),
  ];
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Help center'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (q, a) in faqs) ...[
              Text(q, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(a),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

Future<void> showContactSupport(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Contact support'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email'),
          SelectableText(
            AppData.supportEmail,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text('Phone'),
          SelectableText(
            AppData.supportPhone,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text('Mon - Sat, 9:00 AM to 6:00 PM'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await Clipboard.setData(
                const ClipboardData(text: AppData.supportEmail));
            if (ctx.mounted) Navigator.of(ctx).pop();
            if (context.mounted) _snack(context, 'Email copied.');
          },
          child: const Text('Copy email'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

Future<void> showPrivacyPolicy(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Privacy policy'),
      content: const SingleChildScrollView(
        child: Text(
          'DriveHub stores only the data needed for bookings and your account: '
          'name, email, phone number, profile photo, wishlist, and bookings.\n\n'
          'Your data is not sold to third parties. Your password is securely '
          'handled by Firebase Authentication and is not visible to us.\n\n'
          'Contact support to request data deletion.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

/// Logout confirmation. Returns true if the user confirmed.
Future<bool> confirmLogout(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
  return ok == true;
}

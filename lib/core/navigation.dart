import 'package:flutter/material.dart';
import '../screens/user/user_shell.dart';

Future<T?> pushScreen<T>(BuildContext context, Widget screen) {
  return Navigator.of(context)
      .push<T>(MaterialPageRoute<T>(builder: (_) => screen));
}

/// Clears the whole back stack and shows [screen].
void replaceAll(BuildContext context, Widget screen) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => screen),
    (route) => false,
  );
}

/// Used by screens that sit on top of the main shell (listings, details).
void goToUserTab(BuildContext context, int index) {
  replaceAll(context, UserShell(initialIndex: index));
}

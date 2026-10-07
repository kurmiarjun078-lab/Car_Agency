import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drivehub/main.dart';
import 'package:drivehub/screens/admin/admin_shell.dart';
import 'package:drivehub/screens/auth/login_screen.dart';

void main() {
  testWidgets('splash screen presents premium DriveHub branding', (tester) async {
    await tester.pumpWidget(const DriveHubApp());

    expect(find.text('DriveHub'), findsOneWidget);
    expect(find.text('Luxury mobility, reimagined.'), findsOneWidget);
  });

  testWidgets('login screen exposes admin demo access', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Continue as Admin'), findsOneWidget);
  });

  testWidgets('admin dashboard menu opens actions', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminShell()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Add New Car'), findsOneWidget);
  });
}

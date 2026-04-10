import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_ai_workflow/pages/login/login_view.dart';
import 'package:flutter_ai_workflow/pages/login/login_binding.dart';

void main() {
  group('LoginView Widget Tests', () {
    setUp(() {
      Get.testMode = true;
      LoginBinding().dependencies();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('LoginView renders with welcome text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      expect(find.text('Selamat datang kembali'), findsOneWidget);
    });

    testWidgets('LoginView displays form fields and labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('LoginView displays action buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Lupa password?'), findsOneWidget);
    });

    testWidgets('Email field is interactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      final emailFields = find.byType(TextField);
      expect(emailFields, findsWidgets);

      await tester.tap(emailFields.first);
      await tester.pumpAndSettle();
      await tester.enterText(emailFields.first, 'test@example.com');
      await tester.pumpAndSettle();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      final visibilityButtons = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityButtons, findsWidgets);

      await tester.tap(visibilityButtons.first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsWidgets);
    });

    testWidgets('Loading state has no indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Form is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('LoginView layout has proper structure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('All required text fields present',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('Icons in form are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
        ),
      );

      expect(find.byType(Icon), findsWidgets);
    });
  });
}

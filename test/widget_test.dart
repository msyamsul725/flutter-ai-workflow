import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_ai_workflow/main.dart';
import 'package:flutter_ai_workflow/pages/login/login_controller.dart';

void main() {
  group('LoginView Widget Tests', () {
    late LoginController loginController;

    setUp(() {
      // Initialize GetX in test mode
      Get.testMode = true;
    });

    tearDown(() {
      // Clean up GetX instances
      Get.reset();
    });

    testWidgets('LoginView renders with welcome text', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify welcome text is displayed
      expect(find.text('Selamat datang kembali'), findsOneWidget);
      expect(find.text('Masuk ke akun Anda untuk melanjutkan'), findsOneWidget);
    });

    testWidgets('LoginView displays form fields and labels', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify form labels are displayed
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Verify text fields are displayed
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('LoginView displays action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify main buttons are displayed
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Lupa password?'), findsOneWidget);
    });

    testWidgets('LoginView displays social login options', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify social buttons are displayed
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('LoginView displays sign up link', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify sign up text is displayed
      expect(find.text('Belum punya akun? '), findsOneWidget);
      expect(find.text('Daftar sekarang'), findsOneWidget);
    });

    testWidgets('Email field updates controller text', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Get the controller
      final controller = Get.find<LoginController>();

      // Find and interact with email field
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Verify controller has the email
      expect(controller.emailController.text, 'test@example.com');
    });

    testWidgets('Email validation works for valid email', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<LoginController>();

      // Enter valid email
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'valid@example.com');
      await tester.pumpAndSettle();

      // Verify email validation is triggered
      expect(controller.isEmailValid.value, true);

      // Verify check icon is shown
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('Email validation rejects invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<LoginController>();

      // Enter invalid email
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      // Verify email validation fails
      expect(controller.isEmailValid.value, false);

      // Verify check icon is not shown
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<LoginController>();

      // Verify password is initially hidden
      expect(controller.isPasswordHidden.value, true);

      // Find and tap visibility toggle button
      final visibilityButton = find.byIcon(Icons.visibility_off_outlined);
      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      // Verify password visibility is toggled
      expect(controller.isPasswordHidden.value, false);

      // Tap again to hide password
      final visibilityButtonHide = find.byIcon(Icons.visibility_outlined);
      await tester.tap(visibilityButtonHide);
      await tester.pumpAndSettle();

      // Verify password is hidden again
      expect(controller.isPasswordHidden.value, true);
    });

    testWidgets('Password field accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<LoginController>();

      // Find and interact with password field
      final passwordField = find.byType(TextField).at(1);
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Verify controller has the password
      expect(controller.passwordController.text, 'password123');
    });

    testWidgets('Login button is disabled when loading', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<LoginController>();

      // Set loading state
      controller.isLoading.value = true;
      await tester.pump();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Login button is enabled when not loading', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<LoginController>();

      // Verify loading is false by default
      expect(controller.isLoading.value, false);

      // Verify loading indicator is not shown
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('UI displays all icons correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify all decorative and functional icons are present
      expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.apple), findsOneWidget);
    });

    testWidgets('LoginView is scrollable for small screens', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Try to scroll
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pumpAndSettle();

      // Verify we can scroll without errors
      expect(find.text('Selamat datang kembali'), findsOneWidget);
    });

    testWidgets('Email and password fields are present and editable', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<LoginController>();

      // Clear any existing text
      controller.emailController.clear();
      controller.passwordController.clear();

      // Find text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      // Enter email
      await tester.enterText(textFields.first, 'test@example.com');
      await tester.pumpAndSettle();
      expect(controller.emailController.text, 'test@example.com');

      // Enter password
      await tester.enterText(textFields.at(1), 'testpass123');
      await tester.pumpAndSettle();
      expect(controller.passwordController.text, 'testpass123');
    });

    testWidgets('Scaffold and SafeArea structure is correct', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify Scaffold is present
      expect(find.byType(Scaffold), findsOneWidget);

      // Verify SafeArea is present
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}

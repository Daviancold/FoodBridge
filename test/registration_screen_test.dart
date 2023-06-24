// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbridge_project/main.dart';
import 'package:foodbridge_project/screens/log_in_&_auth/auth_screen.dart';
import 'package:foodbridge_project/screens/log_in_&_auth/login_screen.dart';
import 'package:foodbridge_project/screens/log_in_&_auth/registration_screen.dart';
import 'package:foodbridge_project/widgets/login_registration/user_image_picker.dart';

bool isLogin = true;

void toggle() {
  isLogin = !isLogin;
}

void main() {
  group('Authentication', () {
    testWidgets('Registration Rendering and Validation',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SignUpWidget(
            onClickedSignIn: toggle,
          ),
        ),
      ));

      // Test Wrong Email, Username, Poor Password, Password Mismatch
      await tester.enterText(find.byKey(const Key('EmailKey')), ' ');
      await tester.enterText(find.byKey(const Key('PasswordKey')), ' ');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Please enter a username'), findsOneWidget);
      expect(find.text('Enter min. 6 characters'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);

      // Test Correct Personal Info but with Missing Picture
      await tester.enterText(
          find.byKey(const Key('EmailKey')), 'test@gmail.com');
      await tester.enterText(find.byKey(const Key('UsernameKey')), 'test');
      await tester.enterText(find.byKey(const Key('PasswordKey')), '123456');
      await tester.enterText(
          find.byKey(const Key('ConfirmPasswordKey')), '123456');
      await tester.tap(find.byType(UserImagePicker));
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Enter a valid email'), findsNothing);
      expect(find.text('Please enter a username'), findsNothing);
      expect(find.text('Enter min. 6 characters'), findsNothing);
      expect(find.text('Passwords do not match'), findsNothing);
      expect(find.text('No Image Selected'), findsOneWidget);
    });

    testWidgets('Signing In', (WidgetTester tester) async {
      // Create mock FirebaseAuth instance
      final mockAuth = MockFirebaseAuth();

      // Set FirebaseAuth.instance to the mock instance
      FirebaseAuthWrapper.instance = mockAuth;

      // Create a user in mock database
      const email = 'test@gmail.com';
      const password = '123456';
      final userCredential = MockUserCredential(
        user: MockUser(
          uid: 'test-user-id',
          email: email,
          )
        );

      mockAuth.mockUser = user;

      // Build Login Screen
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: LoginWidget(
            onClickedSignUp: toggle,
          ),
        ),
      ));
      await tester.enterText(
          find.byKey(const Key('EmailSignIn')), 'test@gmail.com');
      await tester.enterText(find.byKey(const Key('PasswordSignIn')), '123456');
      await tester.tap(find.byKey(const Key('Sign In Button')));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that signInWithEmailAndPassword was called with the correct credentials
      //expect(mockAuth., true);
      //expect(mockAuth.signInWithEmailAndPasswordEmail, 'test@example.com');
      //expect(mockAuth.signInWithEmailAndPasswordPassword, 'password');
    });
  });
}

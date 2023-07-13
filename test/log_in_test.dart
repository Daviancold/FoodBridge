import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
          Invocation.method(#signInWithEmailAndPassword, [email, password]),
          returnValue: Future.value(MockUserCredential()));
}

void main() {
  // Create an instance of the mock FirebaseAuth
  final mockFirebaseAuth = MockFirebaseAuth();

  // Inject the mockFirebaseAuth into the widget being tested
  test('Sign In with empty email field throws exception', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: '',
      password: 'password123',
    )).thenThrow(FirebaseAuthException(
      code: 'error',
      message: 'Given String is empty or null',
    ));

    // Trigger the sign in with an empty email field
    expect(() async {
      await mockFirebaseAuth.signInWithEmailAndPassword(
        email: '', // Empty email field
        password: 'password123',
      );
    }, throwsA(isInstanceOf<FirebaseAuthException>()));
  });

  test('Sign In with empty password field throws exception', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: 'hello@gmail.com',
      password: '',
    )).thenThrow(FirebaseAuthException(
      code: 'error',
      message: 'Given String is null or empty',
    ));

    // Trigger the sign in with an empty email field
    expect(() async {
      await mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'hello@gmail.com', // Empty email field
        password: '',
      );
    }, throwsA(isInstanceOf<FirebaseAuthException>()));
  });

  test('Sign In with badly formatted email throws exception', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: '',
      password: '',
    )).thenThrow(FirebaseAuthException(
      code: 'invalid-email',
      message: 'The email address is badly formatted.',
    ));

    // Trigger the sign in with an empty email field
    expect(() async {
      await mockFirebaseAuth.signInWithEmailAndPassword(
        email: '', // Empty email field
        password: '',
      );
    }, throwsA(isInstanceOf<FirebaseAuthException>()));
  });

  test('Sign In with non existent email throws exception', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: 'hello@gmail.com',
      password: 'hello',
    )).thenThrow(FirebaseAuthException(
      code: 'user-not-found',
      message:
          'There is no user record corresponding to this identifier. The user may have been deleted.',
    ));

    // Trigger the sign in with an empty email field
    expect(() async {
      await mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'hello@gmail.com', // Empty email field
        password: 'hello',
      );
    }, throwsA(isInstanceOf<FirebaseAuthException>()));
  });

  test('Invalid password throws exception', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: 'hello@gmail.com',
      password: 'hello',
    )).thenThrow(FirebaseAuthException(
      code: 'wrong-password', // Example error code for wrong password
      message:
          'The password is invalid or the user does not have a password.', // Example error message
    ));

    expect(() async {
      await mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'hello@gmail.com', // Empty email field
        password: 'hello',
      );
    }, throwsA(isInstanceOf<FirebaseAuthException>()));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbridge_project/widgets/chat_widgets/new_message.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockUser extends Mock implements User {}

void main() {
  late _NewMessageState newMessageState;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockChatCollection;
  late MockDocumentReference mockChatDocument;
  late MockCollectionReference mockMessageCollection;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockChatCollection = MockCollectionReference();
    mockChatDocument = MockDocumentReference();
    mockMessageCollection = MockCollectionReference();

    when(mockFirestore.collection('chat')).thenReturn(mockChatCollection);
    when(mockChatCollection.doc(any)).thenReturn(mockChatDocument);
    when(mockChatDocument.collection('messages')).thenReturn(mockMessageCollection);

    newMessageState = _NewMessageState();
    newMessageState.widget = NewMessage(chatId: 'testChatId');
    newMessageState.user = MockUser();
    when(newMessageState.user.email).thenReturn('test@example.com');
    when(newMessageState.user.displayName).thenReturn('Test User');
    when(newMessageState.user.photoURL).thenReturn('https://example.com/avatar.jpg');
  });

  test('Submitting non-empty message adds message to Firestore', () {
    final enteredMessage = 'Hello, world!';

    newMessageState._messageController.text = enteredMessage;
    newMessageState._submitMessage();

    verify(mockFirestore.collection('chat')).called(1);
    verify(mockChatCollection.doc('testChatId')).called(1);
    verify(mockChatDocument.collection('messages')).called(1);
    verify(mockMessageCollection.add({
      'text': enteredMessage,
      'createdAt': any,
      'userId': 'test@example.com',
      'userName': 'Test User',
      'userImage': 'https://example.com/avatar.jpg',
    })).called(1);
  });

  test('Submitting empty message does not add message to Firestore', () {
    newMessageState._messageController.text = '';
    newMessageState._submitMessage();

    verifyNever(mockFirestore.collection('chat'));
    verifyNever(mockChatCollection.doc('testChatId'));
    verifyNever(mockChatDocument.collection('messages'));
    verifyNever(mockMessageCollection.add(any));
  });
}

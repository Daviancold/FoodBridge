import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/widgets/firebase_storage_service.dart';
import 'package:mockito/mockito.dart';

class MockReference extends Mock implements firebase_storage.Reference {}

class MockFirebaseStorage extends Mock implements firebase_storage.FirebaseStorage {}

class MockUploadTask extends Mock implements firebase_storage.UploadTask {}

class

void main() {
  group('FirebaseStorageService', () {
    late MockFirebaseStorage mockFirebaseStorage;
    late MockReference mockReference;

    setUp(() {
      mockFirebaseStorage = MockFirebaseStorage();
      mockReference = MockReference();
      when(mockFirebaseStorage.ref()).thenReturn(mockReference);
    });

    test('uploadImage should upload file to Firebase Storage', () async {
      // Arrange
      final file = File('path_to_file');
      final mockUploadTask = MockUploadTask();
      final expectedImageUrl = 'https://example.com/image.jpg';

      when(mockFirebaseStorage.instance.ref.child)

      when(mockReference.child('listingImages/anyString')).thenReturn(mockReference);
      when(mockReference.putFile(file)).thenReturn(mockUploadTask);
      when(mockReference.getDownloadURL()).thenAnswer((_) {
        return Future.value(expectedImageUrl);
      });

      // Act
      final result = await FirebaseStorageService.uploadImage(file);

      // Assert
      expect(result, expectedImageUrl);
      verify(mockFirebaseStorage.ref());
      verify(mockReference.child('listingImages/anyString'));
      verify(mockReference.putFile(file));
      verify(mockReference.getDownloadURL());
    });

    test('deleteFileByUrl should delete file from Firebase Storage', () async {
      // Arrange
      final fileUrl = 'https://example.com/image.jpg';
      final expectedFilePath = 'listingImages/image.jpg';

      when(mockReference.child(expectedFilePath)).thenReturn(mockReference);
      when(mockReference.delete()).thenAnswer((_) => Future.value(null));

      // Act
      await FirebaseStorageService.deleteFileByUrl(fileUrl);

      // Assert
      verify(mockFirebaseStorage.ref());
      verify(mockReference.child(expectedFilePath));
      verify(mockReference.delete());
      print('File deleted successfully');
    });
  });
}

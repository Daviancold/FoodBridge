import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService {
  static Future<String> uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('listingImages/$fileName');

    await ref.putFile(file);

    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  static Future<void> deleteFileByUrl(String fileUrl) async {
    Uri uri = Uri.parse(fileUrl);
    String filePath = uri.path;
    String decodedFilePath = Uri.decodeComponent(filePath);
    String fileName =
        decodedFilePath.substring(decodedFilePath.lastIndexOf('/') + 1);

    await deleteFile('listingImages/$fileName');

    print('File deleted successfully');
  }

  static Future<void> deleteFile(String filePath) async {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(filePath);
    await ref.delete();
  }
}



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/widgets/image_input/image_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

class MockImagePicker extends Mock implements ImagePicker {
  @override
  Future<XFile?> pickImage({
    int? imageQuality,
    double? maxHeight,
    double? maxWidth,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = false,
    required ImageSource source,
  }) async {
    // Simulate returning an image file
    return XFile('path/to/image.jpg');
  }
}

void main() {
  testWidgets('Initial UI', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageInput(chosenImage: (File image) {}),
        ),
      ),
    );

    final cameraButton = find.byKey(ValueKey('Select from camera button'));
    final galleryButton = find.byKey(ValueKey('Select from gallery button'));

    expect(cameraButton, findsOneWidget);
    expect(galleryButton, findsOneWidget);
  });

  testWidgets('selecting image from camera', (WidgetTester tester) async {
    bool selectedCameraImage = false;
    final mockImagePicker = MockImagePicker();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageInput(chosenImage: (File image) {
            selectedCameraImage = true;
          }),
        ),
      ),
    );

    final cameraButton = find.byKey(ValueKey('Select from camera button'));

    await tester.tap(cameraButton);
    await tester.pumpAndSettle();

    // Simulate returning an image from the camera
    final imageFile = File('path/to/image.jpg');
    await tester.binding.setSurfaceSize(
        Size(800, 600)); // Set a valid surface size for the image
    await tester.binding
        .delayed(Duration(seconds: 1)); // Delay to simulate image processing

    // Call the chosenImage callback with the image file
    final imageInputWidget = tester.widget<ImageInput>(find.byType(ImageInput));
    imageInputWidget.chosenImage(imageFile);
    expect(selectedCameraImage, true);
  });

    testWidgets('selecting image from gallery', (WidgetTester tester) async {
    bool selectedGalleryImage = false;
    final mockImagePicker = MockImagePicker();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageInput(chosenImage: (File image) {
            selectedGalleryImage = true;
          }),
        ),
      ),
    );

    final galleryButton = find.byKey(ValueKey('Select from gallery button'));

    await tester.tap(galleryButton);
    await tester.pumpAndSettle();

    // Simulate returning an image from the camera
    final imageFile = File('path/to/image.jpg');
    await tester.binding.setSurfaceSize(
        Size(800, 600)); // Set a valid surface size for the image
    await tester.binding
        .delayed(Duration(seconds: 1)); // Delay to simulate image processing

    // Call the chosenImage callback with the image file
    final imageInputWidget = tester.widget<ImageInput>(find.byType(ImageInput));
    imageInputWidget.chosenImage(imageFile);
    expect(selectedGalleryImage, true);
  });
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.chosenImage,
  });

  final void Function(File image) chosenImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  //Stores currently selected image
  File? _selectedImage;

  //take picture from camera.
  //if users returns without taking a picture, return
  //if users takes a picture, display that picture as a
  //preview on screen and updates parent widget.
  void _takePicture(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
      widget.chosenImage(_selectedImage!);
    });
  }

  void _promptRetakePhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Retake Photo"),
          content: const Text(
              "Do you want to retake the photo from the gallery or the camera?"),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('Gallery'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _takePicture(ImageSource.gallery);
                  },
                ),
                TextButton(
                  child: const Text('Camera'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _takePicture(ImageSource.camera);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.camera),
          label: const Text('Select from camera'),
          onPressed: () {
            _takePicture(ImageSource.camera);
          },
        ),
        const SizedBox(
          height: 8,
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Select from gallery'),
          onPressed: () {
            _takePicture(ImageSource.gallery);
          },
        ),
      ],
    );

    //Allows user to retake photo
    //if they wish to
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _promptRetakePhoto,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}

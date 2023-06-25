import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/image_input/edit_image_input.dart';
import '../widgets/firestore_service.dart';
import '../widgets/location_input/edit_location_input.dart';
import '../widgets/utils.dart';

class EditListingScreen extends StatefulWidget {
  const EditListingScreen(
      {super.key,
      required this.listing,
      required this.storage,
      required this.docListing});

  final Listing listing;
  final FirebaseStorage storage;
  final DocumentReference docListing;

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  TextEditingController dateInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  MainCategory? selectedMainCategory;
  SubCategory? selectedSubCategory;

  @override
  void dispose() {
    dateInputController.dispose();
    super.dispose();
  }

  //initialize fields to original values. In the event that
  //user does not make any edits, the original values
  //will be retained in the database.
  @override
  void initState() {
    selectedMainCategory = MainCategory.values.firstWhere(
      (mainCat) => mainCat.toString() == widget.listing.mainCategory,
    );
    selectedSubCategory = SubCategory.values.firstWhere(
      (subCat) => subCat.toString() == widget.listing.subCategory,
    );
    dateInputController.text =
        DateFormat('yyyy-MM-dd').format(widget.listing.expiryDate);

    _editedItemName = _itemName;
    _editedAdditionalInfo = _additionalInfo;
    _editedAddress = _address;
    _editedLng = _lng;
    _editedLat = _lat;
    _editedAddressImageUrl = _addressImageUrl;
    _editedSelectedImage = _image;
    _editedChosenDate = _expiryDate;
    _editedChosenMainCategory = _mainCategory;
    _editedChosenSubCategory = _subCategory;
    _editedChosenDietaryOption = _dietaryNeeds;
    _unchangedId = _id;
    _unchangedIsAvailable = _isAvailable;
    _unchangeduserId = _userId;
    _urlLink = _image;

    super.initState();
  }

  String get _itemName {
    return widget.listing.itemName;
  }

  String get _additionalInfo {
    return widget.listing.additionalNotes;
  }

  String get _address {
    return widget.listing.address;
  }

  String get _dietaryNeeds {
    return widget.listing.dietaryNeeds;
  }

  DateTime get _expiryDate {
    return widget.listing.expiryDate;
  }

  String get _id {
    return widget.listing.id;
  }

  String get _image {
    return widget.listing.image;
  }

  bool get _isAvailable {
    return widget.listing.isAvailable;
  }

  double get _lat {
    return widget.listing.lat;
  }

  double get _lng {
    return widget.listing.lng;
  }

  String get _addressImageUrl {
    return widget.listing.addressImageUrl;
  }

  String get _mainCategory {
    return widget.listing.mainCategory;
  }

  String get _subCategory {
    return widget.listing.subCategory;
  }

  String get _userId {
    return widget.listing.userId;
  }

  var _editedItemName;
  var _editedChosenMainCategory;
  var _editedChosenSubCategory;
  var _editedChosenDietaryOption;
  var _editedChosenDate;
  var _editedAdditionalInfo;
  var _editedSelectedImage;
  double? _editedLat;
  double? _editedLng;
  String? _editedAddress;
  String? _editedAddressImageUrl;
  var _unchangedId;
  var _unchangeduserId;
  var _unchangedIsAvailable;
  var _urlLink;
  bool _isSaving = false;

  //upload new image to storage
  // Future<String> uploadImage(File file) async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   firebase_storage.Reference ref =
  //       storage.ref().child('listingImages/$fileName');
  //   await ref.putFile(file);
  //   String imageUrl = await ref.getDownloadURL();
  //   return imageUrl;
  // }

  // //If user uploads new photo, delete old photo in storage
  // Future<void> deleteFileByUrl(String fileUrl) async {
  //     // Extract the file name from the URL
  //     Uri uri = Uri.parse(fileUrl);
  //     String filePath = uri.path;
  //     String decodedFilePath = Uri.decodeComponent(filePath);
  //     String fileName =
  //         decodedFilePath.substring(decodedFilePath.lastIndexOf('/') + 1);
  //     print(fileName);

  //     // Delete the file using the file name
  //     await deleteFile('listingImages/$fileName');

  //     print('File deleted successfully');
  // }

  // Future<void> deleteFile(String filePath) async {
  //   Reference ref = storage.ref().child(filePath);
  //   await ref.delete();
  // }

  //save updates made by user, if any
  void _saveItem() async {
    if (_editedSelectedImage == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Picture missing',
            textAlign: TextAlign.center,
          ),
          content: const SizedBox(
            height: 16,
            width: 32,
            child: Center(
              child: Text('Add a picture'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('ok'),
            ),
          ],
        ),
      );
      return;
    }
    if (_editedAddress == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Address missing',
            textAlign: TextAlign.center,
          ),
          content: const SizedBox(
            height: 16,
            width: 32,
            child: Center(
              child: Text('Click on get address'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('ok'),
            ),
          ],
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });
      _formKey.currentState!.save();
      try {
        FirebaseStorageService imageService = FirebaseStorageService();
        if (_editedSelectedImage == _image) {
          _urlLink = _editedSelectedImage;
        } else {
          await imageService.deleteFileByUrl(_image);
          _urlLink =
              await imageService.uploadImage(_editedSelectedImage);
        }
        final data = {
          'additionalNotes': _editedAdditionalInfo,
          'address': _editedAddress,
          'dietaryNeeds': _editedChosenDietaryOption,
          'expiryDate': _editedChosenDate,
          'image': _urlLink,
          'itemName': _editedItemName,
          'lat': _editedLat,
          'lng': _editedLng,
          'addressImageUrl': _editedAddressImageUrl,
          'mainCategory': _editedChosenMainCategory,
          'subCategory': _editedChosenSubCategory,
        };

        await FirestoreService.updateListing(data, widget.docListing.id);

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text('Edits are saved'),
          ),
        );
      } catch (e) {
        Utils.showSnackBar('error: $e');
      }
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  //date picker, formatted
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    final lastDate = DateTime(now.year + 2, now.month, now.day);
    final pickedDate = await showDatePicker(
      // returned value is a future
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        _editedChosenDate = pickedDate;
      });
      dateInputController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Listing',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              EditImageInput(
                listing: widget.listing,
                chosenImage: (File image) {
                  setState(() {
                    _editedSelectedImage = image;
                  });
                },
              ),
              // for selecting image
              TextFormField(
                initialValue: _editedItemName,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name of item'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters long';
                  }
                },
                onSaved: (value) {
                  _editedItemName = value!.trim().toUpperCase();
                },
              ),

              const SizedBox(
                height: 8,
              ),

              DropdownButtonFormField<MainCategory>(
                value: selectedMainCategory,
                items: MainCategory.values.map((mainCat) {
                  return DropdownMenuItem<MainCategory>(
                    value: mainCat,
                    child: Text(mainCat.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (mainCat) {
                  setState(() {
                    selectedMainCategory = mainCat;
                    selectedSubCategory = null;
                  });
                },
                decoration: const InputDecoration(
                  label: Text('Select main category'),
                  hintText: 'Select main category',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Must select main category';
                  }
                },
                onSaved: (value) {
                  _editedChosenMainCategory = value.toString();
                },
              ),

              const SizedBox(
                height: 8,
              ),

              DropdownButtonFormField<SubCategory>(
                value: selectedSubCategory,
                items: selectedMainCategory != null
                    ? categorySubcategoryMap[selectedMainCategory]!
                        .map((subCat) {
                        return DropdownMenuItem<SubCategory>(
                          value: subCat,
                          child: Text(subCat.toString().split('.').last),
                        );
                      }).toList()
                    : [],
                onChanged: (subCat) {
                  setState(() {
                    selectedSubCategory = subCat;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Select subcategory',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Must select subcategory';
                  }
                },
                onSaved: (value) {
                  _editedChosenSubCategory = value.toString();
                },
              ),
              DropdownButtonFormField(
                value: DietaryNeeds.values.firstWhere(
                  (dietaryOption) =>
                      dietaryOption.toString() == widget.listing.dietaryNeeds,
                ),
                hint: const Text('Select dietary specifications'),
                items: [
                  for (final category in DietaryNeeds.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    )
                ],
                onChanged: (value) {},
                validator: (value) {
                  if (value == null) {
                    return 'Must select dietary specifications';
                  }
                },
                onSaved: (value) {
                  _editedChosenDietaryOption = value.toString();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Select expiry date',
                      ),
                      controller: dateInputController,
                      onTap: _presentDatePicker,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                      },
                      onSaved: (value) {
                        _editedChosenDate = DateTime.tryParse(value!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              EditLocationInput(
                listing: widget.listing,
                chosenLocation: (UserLocation? location) {
                  _editedLat = location?.latitude;
                  _editedLng = location?.longitude;
                  _editedAddress = location?.address;
                  _editedAddressImageUrl = location?.addressImageUrl;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                initialValue: _editedAdditionalInfo,
                maxLines: 5,
                maxLength: 200,
                decoration: InputDecoration(
                  label: const Text('Additional details'),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().length <= 1 ||
                      value.trim().length > 200) {
                    return 'Must be between 1 and 200 characters long';
                  }
                },
                onSaved: (value) {
                  _editedAdditionalInfo = value;
                },
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveItem,
                    icon: _isSaving
                        ? const SizedBox(
                            height: 8,
                            width: 8,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Icons.save),
                    label:
                        _isSaving ? const Text('Saving') : const Text('Save'),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

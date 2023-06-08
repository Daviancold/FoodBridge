import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:foodbridge_project/widgets/image_input.dart';
import 'package:foodbridge_project/widgets/location_input.dart';
import 'package:intl/intl.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class NewListingScreen extends StatefulWidget {
  const NewListingScreen({super.key});

  @override
  State<NewListingScreen> createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  MainCategory? selectedMainCategory;
  SubCategory? selectedSubCategory;
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateInputController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  var _itemName;
  var _userId;
  var _chosenMainCategory;
  var _chosenSubCategory;
  var _chosenDietaryOption;
  var _chosenDate;
  var _additionalInfo;
  var _selectedImage;
  var _isExpired;
  var _lat;
  var _lng;
  var _address;

  Future<String> uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref =
        storage.ref().child('listingImages/$fileName');
    await ref.putFile(file);
    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> createListing({
    required String itemName,
    required String urlLink,
    required String mainCat,
    required String subCat,
    required String dietaryInfo,
    required String addInfo,
    required DateTime expDate,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final docListing = FirebaseFirestore.instance.collection('Listings').doc();

    final listing = Listing(
      itemName: itemName,
      image: urlLink,
      mainCategory: mainCat,
      subCategory: subCat,
      dietaryNeeds: dietaryInfo,
      additionalNotes: addInfo,
      expiryDate: expDate,
      lat: lat,
      lng: lng,
      address: address,
      isExpired: DateTime.now().isAfter(expDate),
      userId: FirebaseAuth.instance.currentUser!.email.toString(),
    );

    final json = listing.toJson();
    await docListing.set(json);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 2, now.month, now.day);
    final pickedDate = await showDatePicker(
      // returned value is a future
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        _chosenDate = pickedDate;
      });
      dateInputController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  void _saveItem() async {
    if (_selectedImage == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Picture missing',
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 16,
            width: 32,
            child: Center(
              child: const Text('Add a picture'),
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
    if (_address == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Address missing',
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 16,
            width: 32,
            child: Center(
              child: const Text('Click on get address'),
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
    final urlLink = await uploadImage(_selectedImage);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      createListing(
        itemName: _itemName!,
        urlLink: urlLink!,
        mainCat: _chosenMainCategory!,
        subCat: _chosenSubCategory!,
        dietaryInfo: _chosenDietaryOption!,
        addInfo: _additionalInfo!,
        expDate: _chosenDate!,
        lat: _lat!,
        lng: _lng!,
        address: _address!,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Add new listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ImageInput(
                  chosenImage: (File image) {
                    setState(() {
                      _selectedImage = image;
                    });
                  }, //TODO handle if no image taken
                ), // for selecting image
                TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(
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
                    _itemName = value;
                  },
                ),
                SizedBox(
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
                      selectedSubCategory = null; // Clear the selected subCat
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Select main category',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Must select main category';
                    }
                  },
                  onSaved: (value) {
                    _chosenMainCategory = value.toString();
                  },
                ),
                SizedBox(
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
                  decoration: InputDecoration(
                    hintText: 'Select subcategory',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Must select sub category';
                    }
                  },
                  onSaved: (value) {
                    _chosenSubCategory = value.toString();
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField(
                  hint: Text('Select dietary specifications'),
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
                      return 'Must select deitary specifications';
                    }
                  },
                  onSaved: (value) {
                    _chosenDietaryOption = value.toString();
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
                          _chosenDate = DateTime.tryParse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                LocationInput(
                  chosenLocation: (UserLocation location) {
                    _lat = location.latitude;
                    _lng = location.longitude;
                    _address = location.address;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  maxLines: 5,
                  maxLength: 200,
                  decoration: InputDecoration(
                    label: Text('Additional details'),
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
                    _additionalInfo = value;
                  },
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel),
                      label: Text('Cancel'),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: _saveItem,
                      icon: Icon(Icons.save),
                      label: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

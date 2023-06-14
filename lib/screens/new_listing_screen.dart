import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:foodbridge_project/widgets/image_input.dart';
import 'package:foodbridge_project/widgets/location_input.dart';
import 'package:intl/intl.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/utils.dart';

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

  @override
  void dispose() {
    dateInputController.dispose();
    super.dispose();
  }

  // ignore: prefer_typing_uninitialized_variables
  var _itemName;
  // ignore: prefer_typing_uninitialized_variables
  var _chosenMainCategory;
  // ignore: prefer_typing_uninitialized_variables
  var _chosenSubCategory;
  // ignore: prefer_typing_uninitialized_variables
  var _chosenDietaryOption;
  // ignore: prefer_typing_uninitialized_variables
  var _chosenDate;
  // ignore: prefer_typing_uninitialized_variables
  var _additionalInfo;
  // ignore: prefer_typing_uninitialized_variables
  var _selectedImage;
  // ignore: prefer_typing_uninitialized_variables
  var _lat;
  // ignore: prefer_typing_uninitialized_variables
  var _lng;
  // ignore: prefer_typing_uninitialized_variables
  var _address;
  bool _isSaving = false;

  //takes an image file, upload it to firebase storage and returns url
  Future<String> uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('listingImages/$fileName');

    await ref.putFile(file);

    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  //Goes to firestore collection 'Listings'.
  //Create new document and retrieve doc id.
  //Put the doc id inside the doc as a field for future references
  //Converts listing data to json format.
  //Overwrite any data inside that document with listing data (should
  //be empty in the first place by right).
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

    final user = FirebaseAuth.instance.currentUser!;

    final listing = Listing(
      id: docListing.id,
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
      isAvailable: true,
      userId: user.email.toString(),
      userName: user.displayName.toString(),
    );

    final json = listing.toJson();
    await docListing.set(json);
  }

  //Pops up date picker to pick expiry date
  //Users can only select dates 1 day after the date
  //at time of selecting. For example, today's date is
  //22/05/2023, then you can only select 23/05/2023 onwards
  //with maximum difference of 2 years.
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
        _chosenDate = pickedDate;
      });
      dateInputController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  //Validates user input first.
  //If validation fails, prompt user to check entries.
  //If validation passes, create new listing on firestore
  void _saveItem() async {
    if (_selectedImage == null) {
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
    if (_address == null) {
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
        final urlLink = await uploadImage(_selectedImage);

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
      } catch (e) {
        Utils.showSnackBar('error: $e');
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: const Text(
          'ADD NEW LISTING',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //For selecting image
                ImageInput(
                  chosenImage: (File image) {
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                ),
                //Item name
                TextFormField(
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
                    _itemName = value!.trim().toUpperCase();
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                //Main category
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
                  decoration: const InputDecoration(
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
                const SizedBox(
                  height: 8,
                ),
                //Subcategory
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
                      return 'Must select sub category';
                    }
                  },
                  onSaved: (value) {
                    _chosenSubCategory = value.toString();
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                //dietary specifications
                DropdownButtonFormField(
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
                    _chosenDietaryOption = value.toString();
                  },
                ),
                //Expiry date
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
                const SizedBox(
                  height: 16,
                ),
                //Retrieving location
                LocationInput(
                  chosenLocation: (UserLocation location) {
                    _lat = location.latitude;
                    _lng = location.longitude;
                    _address = location.address;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                //Additional details
                TextFormField(
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
                    _additionalInfo = value;
                  },
                ),
                //cancel and save button
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

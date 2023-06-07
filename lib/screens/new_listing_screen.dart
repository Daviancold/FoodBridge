import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodbridge_project/widgets/image_input.dart';
import 'package:foodbridge_project/widgets/location_input.dart';
import 'package:intl/intl.dart';
import 'package:foodbridge_project/models/listing.dart';

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

  var _itemName;
  // var _image;
  var _chosenMainCategory;
  var _chosenSubCategory;
  var _chosenDietaryOption;
  var _chosenDate;
  var _additionalInfo;
  var _selectedImage;
  var _chosenLocation;

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

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(
        context,
        Listing(
          image: _selectedImage,
          itemName: _itemName,
          mainCategory: _chosenMainCategory,
          subCategory: _chosenSubCategory,
          dietaryNeeds: _chosenDietaryOption,
          additionalNotes: _additionalInfo,
          expiryDate: _chosenDate,
          location: _chosenLocation,
        ),
      );
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
                    _selectedImage = image;
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
                    _chosenMainCategory = value;
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
                    _chosenSubCategory = value;
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
                    _chosenDietaryOption = value;
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
                    _chosenLocation = location;
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

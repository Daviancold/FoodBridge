import 'package:flutter/material.dart';

List<String> selectedFoodTypes = [];
List<String> selectedDietaryNeeds = []; // Stores selection

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<Category> categories = [
    Category(
      'Food Types',
      [
        Subcategory('Baby Food'),
        Subcategory('Baked Goods'),
        Subcategory(
          'Dairy, Chilled and Eggs',
          [
            'Eggs',
            'Milk',
            'Cheese',
            'Butter, Margarine and Spreads',
            'Cream',
            'Yoghurt',
          ],
        ),
        Subcategory(
          'Beverages',
          [
            'Coffee',
            'Tea',
            'Juices',
            'Soft Drinks',
            'Others',
          ],
        ),
        Subcategory(
          'Pantry Essentials',
          [
            'Canned',
            'Rice',
            'Pasta',
            'Noodles',
            'Cereal',
            'Condiments',
            'Baking Needs',
            'Oil',
          ],
        ),
        Subcategory('Frozen', [
          'Desserts',
          'Meat',
          'Seafoods',
        ]),
        Subcategory('Fruits and Vegetables', [
          'Fruits',
          'Vegetables',
        ]),
        Subcategory('Meat and Seafood', [
          'Chicken',
          'Pork',
          'Beef',
          'Lamb',
          'Seafood',
        ]),
        Subcategory('Others '),
      ],
    ),
    Category(
      'Dietary Needs',
      [
        Subcategory('Halal'),
        Subcategory('Kosher'),
        Subcategory('Contains Lactose'),
        Subcategory('Contains Nuts'),
        Subcategory('Contains Soy'),
        Subcategory('None'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, categoryIndex) {
              final category = categories[categoryIndex];
              return ExpansionTile(
                title: Text(
                  category.name,
                  style: const TextStyle(color: Colors.white),
                ),
                children: category.subcategories.map((subcategory) {
                  if (subcategory.options != null &&
                      subcategory.options!.isNotEmpty) {
                    return _buildExpandableSubcategoryTile(category, subcategory);
                  } else {
                    return _buildCheckboxSubcategoryTile(category, subcategory);
                  }
                }).toList(),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () {
                  selectedFoodTypes.clear();
                  selectedDietaryNeeds.clear();
                  setState(() {});
                },
                child: const Text('Reset'),
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    //'Food Types': selectedFoodTypes,
                    //'Dietary Needs': selectedDietaryNeeds,
                  });
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSubcategoryTile(
      Category category, Subcategory subcategory) {
    return ExpansionTile(
      title: Text(
        subcategory.name,
        style: const TextStyle(color: Colors.white),
      ),
      children: subcategory.options!.map((option) {
        return CheckboxListTile(
          title: Text(option, style: const TextStyle(color: Colors.white)),
          value: _isSubcategorySelected(category, subcategory, option),
          onChanged: (value) {
            setState(() {
              _toggleSubcategorySelection(category, subcategory, option, value);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxSubcategoryTile(
      Category category, Subcategory subcategory) {
    bool isDietaryNeedsSubcategory = (category.name == 'Dietary Needs');
    bool isAnyOptionSelected = _isSubcategorySelected(category, subcategory);
    bool isGreyedOut = isDietaryNeedsSubcategory && isAnyOptionSelected;

    return CheckboxListTile(
      title: Text(subcategory.name,
          style: TextStyle(color: isGreyedOut ? Colors.grey : Colors.white)),
      value: isAnyOptionSelected,
      onChanged: (value) {
        setState(() {
          if (isDietaryNeedsSubcategory && value != null && value) {
            // If it's the "Dietary Needs" subcategory and a new option is being selected
            selectedDietaryNeeds.clear(); // Clear all previous selections
            selectedDietaryNeeds
                .add(subcategory.name); // Add the selected option
          } else {
            _toggleSubcategorySelection(category, subcategory, null, value);
          }
        });
      },
      activeColor: isDietaryNeedsSubcategory
          ? Colors.grey
          : null, // Set the active color to grey for "Dietary Needs"
      checkColor: isDietaryNeedsSubcategory
          ? Colors.white
          : null, // Set the check color to white for "Dietary Needs"
    );
  }

  bool _isSubcategorySelected(Category category, Subcategory subcategory,
      [String? option]) {
    if (category.name == 'Food Types') {
      if (option != null) {
        return selectedFoodTypes.contains(option);
      } else {
        return selectedFoodTypes.contains(subcategory.name);
      }
    } else if (category.name == 'Dietary Needs') {
      if (option != null) {
        return selectedDietaryNeeds.contains(option);
      } else {
        return selectedDietaryNeeds.contains(subcategory.name);
      }
    }
    return false;
  }

  void _toggleSubcategorySelection(
      Category category, Subcategory subcategory, String? option, bool? value) {
    if (category.name == 'Food Types') {
      if (value != null && value) {
        if (option != null) {
          selectedFoodTypes.add(option);
        } else {
          selectedFoodTypes.add(subcategory.name);
        }
      } else {
        if (option != null) {
          selectedFoodTypes.remove(option);
        } else {
          selectedFoodTypes.remove(subcategory.name);
        }
      }
    } else if (category.name == 'Dietary Needs') {
      if (value != null && value) {
        if (option != null) {
          selectedDietaryNeeds.add(option);
        } else {
          selectedDietaryNeeds.add(subcategory.name);
        }
      } else {
        if (option != null) {
          selectedDietaryNeeds.remove(option);
        } else {
          selectedDietaryNeeds.remove(subcategory.name);
        }
      }
    }
  }
}

class Category {
  final String name;
  final List<Subcategory> subcategories;

  Category(this.name, this.subcategories);
}

class Subcategory {
  final String name;
  final List<String>? options;

  Subcategory(this.name, [this.options]);
}

import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/tabs_screen.dart';

List<String> selectedOptions = []; // Stores selection

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});
  @override
  State<FilterWidget> createState() {
    return _FilterWidgetState();
  }
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
          ],
        ),
        Subcategory('Pantry Essentials', [
          'Canned',
          'Rice',
          'Pasta',
          'noodles',
          'Cereal',
          'Condiments',
          'Baking Needs',
          'Oil',
        ]),
        //Subcategory('Subcategory 1.2'),
        //Subcategory('Subcategory 1.2'),
        //Subcategory('Subcategory 1.2'),
        //Subcategory('Subcategory 1.2'),
      ],
    ),
    Category(
      'Dietary Needs',
      [
        Subcategory('Subcategory 2.1', ['Option 2.1', 'Option 2.2']),
        Subcategory('Subcategory 2.2'),
      ],
    ),
    Category(
      'Category 3',
      [
        Subcategory('Subcategory 3.1', ['Option 3.1', 'Option 3.2']),
        Subcategory('Subcategory 3.2', ['Option 3.3']),
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
              return ExpansionTile(
                title: Text(categories[categoryIndex].name),
                children:
                    categories[categoryIndex].subcategories.map((subcategory) {
                  if (subcategory.options != null &&
                      subcategory.options!.isNotEmpty) {
                    return _buildExpandableSubcategoryTile(subcategory);
                  } else {
                    return _buildCheckboxSubcategoryTile(subcategory);
                  }
                }).toList(),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () {
                selectedOptions.clear();
                setState(() {});
              },
              child: Text('Clear'),
            ),
            const SizedBox(
              width: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  const TabsScreen();
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableSubcategoryTile(Subcategory subcategory) {
    return ExpansionTile(
      title: Text(subcategory.name),
      children: subcategory.options!.map((option) {
        return CheckboxListTile(
          title: Text(option),
          value: selectedOptions.contains(option),
          onChanged: (value) {
            setState(() {
              if (value != null && value) {
                selectedOptions.add(option);
              } else {
                selectedOptions.remove(option);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxSubcategoryTile(Subcategory subcategory) {
    return CheckboxListTile(
      title: Text(subcategory.name),
      value: selectedOptions.contains(subcategory.name),
      onChanged: (value) {
        setState(() {
          if (value != null && value) {
            selectedOptions.add(subcategory.name);
          } else {
            selectedOptions.remove(subcategory.name);
          }
        });
      },
    );
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

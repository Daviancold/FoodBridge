import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

enum MainCategory {
  babyFood,
  bakedGoods,
  dairyChilledAndEggs,
  beverages,
  pantryEssentials,
  frozen,
  fruitsAndVegetables,
  meatAndSeafood,
  others,
}

enum SubCategory {
  // Baby Food
  babyFood,

  // Baked Goods
  bakedGoods,

  // Dairy, Chilled and Eggs
  eggs,
  milk,
  cheese,
  butterMargarineAndSpreads,
  cream,
  yogurt,

  // Beverages
  coffee,
  tea,
  juices,
  softDrinks,

  // Pantry Essentials
  canned,
  rice,
  pasta,
  noodles,
  cereal,
  condiments,
  bakingNeeds,
  oil,

  // Frozen
  desserts,
  meat,
  seafood,

  // Fruits and Vegetables
  fruits,
  vegetables,

  // Meat and Seafood
  chicken,
  pork,
  beef,
  lamb,
  seafoods,

  // Others
  others,
}

enum DietaryNeeds {
  halal,
  kosher,
  lactoseFree,
  nutFree,
  shellfishFree,
  soyFree,
  others,
}

Map<MainCategory, List<SubCategory>> categorySubcategoryMap = {
  MainCategory.babyFood: [
    SubCategory.babyFood,
  ],
  MainCategory.bakedGoods: [
    SubCategory.bakedGoods,
  ],
  MainCategory.dairyChilledAndEggs: [
    SubCategory.eggs,
    SubCategory.milk,
    SubCategory.cheese,
    SubCategory.butterMargarineAndSpreads,
    SubCategory.cream,
    SubCategory.yogurt,
  ],
  MainCategory.beverages: [
    SubCategory.coffee,
    SubCategory.tea,
    SubCategory.juices,
    SubCategory.softDrinks,
  ],
  MainCategory.pantryEssentials: [
    SubCategory.canned,
    SubCategory.rice,
    SubCategory.pasta,
    SubCategory.noodles,
    SubCategory.cereal,
    SubCategory.condiments,
    SubCategory.bakingNeeds,
    SubCategory.oil,
  ],
  MainCategory.frozen: [
    SubCategory.desserts,
    SubCategory.meat,
    SubCategory.seafood,
  ],
  MainCategory.fruitsAndVegetables: [
    SubCategory.fruits,
    SubCategory.vegetables,
  ],
  MainCategory.meatAndSeafood: [
    SubCategory.chicken,
    SubCategory.pork,
    SubCategory.beef,
    SubCategory.lamb,
    SubCategory.seafood,
  ],
  MainCategory.others: [
    SubCategory.others,
  ],
};

class UserLocation {
  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class Listing {

  Listing({
    required this.itemName,
    required this.image,
    required this.mainCategory,
    required this.subCategory,
    required this.dietaryNeeds,
    required this.additionalNotes,
    required this.expiryDate,
    required this.location,
  })  : isExpired = DateTime.now().isAfter(expiryDate),
        userId = FirebaseAuth.instance.currentUser!.email.toString();

  final String userId; //not necessary?
  final String itemName;
  final File image; //change type
  final MainCategory mainCategory;
  final SubCategory subCategory;
  final DietaryNeeds dietaryNeeds;
  final String additionalNotes;
  final DateTime expiryDate;
  final bool isExpired;
  final UserLocation location;
}

import 'package:cloud_firestore/cloud_firestore.dart';

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
  containsLactose,
  containsNuts,
  containShellfish,
  containsSoy,
  others,
  none,
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
  Listing(
      {required this.itemName,
      required this.image,
      required this.mainCategory,
      required this.subCategory,
      required this.dietaryNeeds,
      required this.additionalNotes,
      required this.expiryDate,
      required this.lat,
      required this.lng,
      required this.address,
      required this.isAvailable,
      required this.userId});
  // : isAvailable = DateTime.now().isAfter(expiryDate),
  //       userId = FirebaseAuth.instance.currentUser!.email.toString();

  final String userId; //not necessary?
  final String itemName;
  final String image; //change type //
  final String mainCategory; //
  final String subCategory; //
  final String dietaryNeeds; //
  final String additionalNotes;
  final DateTime expiryDate;
  final bool isAvailable;
  final double lat;
  final double lng;
  final String address; //

  static Listing fromJson(Map<String, dynamic> json) => Listing(
      itemName: json['itemName'],
      userId: json['userId'],
      image: json['image'],
      mainCategory: json['mainCategory'],
      subCategory: json['subCategory'],
      dietaryNeeds: json['dietaryNeeds'],
      expiryDate: (json['expiryDate'] as Timestamp).toDate(),
      isAvailable: json['isAvailable'],
      lat: json['lat'],
      lng: json['lng'],
      address: json['address'],
      additionalNotes: json['additionalNotes']);

  Map<String, dynamic> toJson() => {
    'itemName': itemName,
    'userId': userId,
    'image': image,
    'mainCategory': mainCategory,
    'subCategory': subCategory,
    'dietaryNeeds': dietaryNeeds,
    'additionalNotes': additionalNotes,
    'expiryDate': expiryDate,
    'isAvailable': isAvailable,
    'lat': lat,
    'lng': lng,
    'address': address
      };
}

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

enum Region {
  central,
  north,
  northEast,
  east,
  west,
}

enum Location {
  //Central
  bishan,
  bukitMerah,
  bukitTimah,
  downtownCore,
  geylang,
  kallang,
  marinaEast,
  marinaSouth,
  marinaParade,
  museum,
  newton,
  novena,
  orchard,
  outram,
  queenstown,
  riverValley,
  rochor,
  singaporeRiver,
  southernIslands,
  straitsView,
  tanglin,
  toaPayoh,

  // north
  centralWaterCatchment,
  limChuKang,
  mandai,
  sembawang,
  simpang,
  sungeiKadut,
  woodlands,
  yishun,

  //north east
  angMoKio,
  hougang,
  northenEastenIslands,
  punggol,
  seletar,
  sengkang,
  serangoon,

  //east
  bedok,
  changi,
  changibay,
  pasirRis,
  payaLebar,
  tampines,
  boonLay,
  bukitBatok,
  bukitPanjang,
  choaChukang,
  clementi,
  jurongEast,
  jurongWest,
  pioneer,
  tengah,
  tuas,
  westernIslands,
  westernWaterCatchment,
}

class Listing {
  const Listing({
    required this.id,
    required this.itemName,
    required this.imageUrl,
    required this.mainCategory,
    required this.subCategory,
    required this.dietaryNeeds,
    required this.additionalNotes,
    required this.expiryDate,
    required this.region,
    required this.location,
  });

  final String id;
  final String itemName;
  final String imageUrl;
  final MainCategory mainCategory;
  final SubCategory subCategory;
  final DietaryNeeds dietaryNeeds;
  final String additionalNotes;
  final DateTime expiryDate;
  final Region region;
  final Location location;
}

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

  //west
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

Map<Region, List<Location>> regionLocationMap = {
  Region.central: [
    Location.bishan,
    Location.bukitMerah,
    Location.bukitTimah,
    Location.downtownCore,
    Location.geylang,
    Location.kallang,
    Location.marinaEast,
    Location.marinaSouth,
    Location.marinaParade,
    Location.museum,
    Location.newton,
    Location.novena,
    Location.orchard,
    Location.outram,
    Location.queenstown,
    Location.riverValley,
    Location.rochor,
    Location.singaporeRiver,
    Location.southernIslands,
    Location.straitsView,
    Location.tanglin,
    Location.toaPayoh,
  ],
  Region.north: [
    Location.centralWaterCatchment,
    Location.limChuKang,
    Location.mandai,
    Location.sembawang,
    Location.simpang,
    Location.sungeiKadut,
    Location.woodlands,
    Location.yishun,
    // Add more locations for the north region
  ],
  Region.northEast: [
    Location.angMoKio,
    Location.hougang,
    Location.northenEastenIslands,
    Location.punggol,
    Location.seletar,
    Location.sengkang,
    Location.serangoon,
    // Add more locations for the northeast region
  ],

  Region.east: [
    Location.bedok,
    Location.changi,
    Location.changibay,
    Location.pasirRis,
    Location.payaLebar,
    Location.tampines,
  ],

  Region.west: [
    Location.boonLay,
    Location.bukitBatok,
    Location.bukitPanjang,
    Location.choaChukang,
    Location.clementi,
    Location.jurongEast,
    Location.jurongWest,
    Location.pioneer,
    Location.tengah,
    Location.tuas,
    Location.westernIslands,
    Location.westernWaterCatchment,
  ],
  // Add more region-location mappings as needed
};

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

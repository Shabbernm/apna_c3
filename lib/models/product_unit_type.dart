import 'package:flutter/foundation.dart';

class ProductUnitType {
  final String id;
  final String name;
  final String description;

  ProductUnitType({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class ProductUnitTypes {
  static List<ProductUnitType> _items = [];

  static List<ProductUnitType> get items {
    return [..._items];
  }

  static void addProductUnitType(ProductUnitType productUnitType) {
    bool found = false;
    _items.forEach((item) {
      if (item.id == productUnitType.id) {
        found = true;
      }
    });
    if(found == false){
      _items.add(productUnitType);
    }
  }

  static ProductUnitType classMapToObj(Map<String, dynamic> localMap) {
    return ProductUnitType(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
      );
  }
}

import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String productSubcategory;
  final String productBrand;
  final String productUnitType;
  final String description;
  final int barcode;
  final String image;
  final String slug;
  bool available;

  Product({
    @required this.id,
    @required this.name,
    @required this.productSubcategory,
    @required this.productBrand,
    @required this.productUnitType,
    @required this.description,
    @required this.barcode,
    @required this.image,
    @required this.slug,
    this.available = false,
  });
}

class Products {
  static List<Product> _items = [];
  static List<Product> _itemsList2 = [];

  static List<Product> get items {
    return [..._items];
  }

  static List<Product> get itemsList2 {
    return [..._itemsList2];
  }

  static void addProductToLocalList(Product prod) {
    bool prodFound = false;
    _items.forEach((item) {
      if (item.id == prod.id) {
        prodFound = true;
      }
    });
    if (prodFound == false) {
      _items.add(prod);
      _itemsList2.add(prod);
    }    
  }

  static void clearLocalList() {
    _items.clear();
    // _itemsList2.clear();
  }

  static Product classMapToObj(Map<String, dynamic> localMap) {
    return Product(
        id: localMap['id'].toString(),
        name: localMap['name'],
        productSubcategory:
            localMap['Product_Subcategory']['id'].toString(),
        productBrand: localMap['Product_Brand']['id'].toString(),
        productUnitType: localMap['Product_Unit_Type']['id'].toString(),
        description: localMap['description'],
        barcode: localMap['barcode'],
        image: localMap['image'],
        slug: localMap['slug'],
      );
  }
}

import 'package:flutter/foundation.dart';

class ProductCategory {
  final String id;
  final String name;
  final String description;
  final String shopCategory;
  final String image;
  final String slug;
  bool active;

  ProductCategory({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.shopCategory,
    @required this.image,
    @required this.slug,
    this.active = false,
  });
}

class ProductCategories {
  static List<ProductCategory> _items = [];

  static List<ProductCategory> get items {
    return [..._items];
  }

  static void addProductCategoryToLocalList(ProductCategory productCategory) {
    bool found = false;
    // print('productCategory');
    // print(productCategory);
    _items.forEach((temp) {
      if (temp.id == productCategory.id) {
        found = true;
      }
    });
    if (found == false) {
      _items.add(productCategory);
    }
  }

  static void clearLocalList(){
    _items.clear();
  }

  static ProductCategory classMapToObj(Map<String, dynamic> localMap) {
    // print('localMap');
    // print(localMap);
    return ProductCategory(
      id: localMap['id'].toString(),
      name: localMap['Name'],
      description: localMap['Description'],
      shopCategory: localMap['Shop_Category'].toString(),
      image: localMap['image'],
      slug: localMap['slug'],
    );
  }
}

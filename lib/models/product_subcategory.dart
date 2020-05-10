import 'package:apna_c3/models/shop_products_category.dart';
import 'package:flutter/foundation.dart';

import '../models/product_category.dart';

class ProductSubcategory {
  final String id;
  final String name;
  final String description;
  final String productCategory;

  ProductSubcategory({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.productCategory,
  });
}

class ProductSubcategories {
  static List<ProductSubcategory> _items = [];
  static List<ProductSubcategory> _itemsList2 = [];

  static List<ProductSubcategory> get items {
    return [..._items];
  }

  static List<ProductSubcategory> get itemsList2 {
    return [..._itemsList2];
  }

  static void addProductSubcategory(ProductSubcategory productSubcategory) {
    bool founded = false;
    _items.forEach((subcategory) {
      if (subcategory.id == productSubcategory.id) {
        founded = true;
      }
    });
    if (founded == false) {
      _items.add(productSubcategory);
      _itemsList2.add(productSubcategory);
    }
  }

  static void clearLocalList() {
    _items.clear();
  }

  static ProductSubcategory classMapToObj(Map<String, dynamic> localMap) {
    // print(ProductCategories.classMapToObj(localMap['Product_Category']));
    ProductCategories.addProductCategoryToLocalList(
        ProductCategories.classMapToObj(localMap['Product_Category']));
    return ProductSubcategory(
      id: localMap['id'].toString(),
      name: localMap['Name'],
      description: localMap['Description'],
      productCategory: localMap['Product_Category']['id'].toString(),
    );
  }

  static List<ProductSubcategory> getProductSubcategoriesByShopId(
      String shopId) {
    List<ProductSubcategory> localList = [];

    String productsCategoryId =ShopProductsCategories.items.firstWhere(
        (shopProductsCategory) => shopProductsCategory.shop == shopId).productCategory;
    _items.forEach((productSubcategory) {
      if (productSubcategory.productCategory == productsCategoryId) {
        localList.add(productSubcategory);
      }
    });
    return localList;
  }
}

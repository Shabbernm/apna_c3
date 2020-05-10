import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../providers/conf_data.dart';
import './product_category.dart';

class ShopProductsCategory {
  final String id;
  final String shop;
  final String productCategory;
  final String slug;

  ShopProductsCategory({
    @required this.id,
    @required this.shop,
    @required this.productCategory,
    @required this.slug,
  });
}

class ShopProductsCategories {
  static List<ShopProductsCategory> _items = [];

  static List<ShopProductsCategory> get items {
    return [..._items];
  }

  static Future<List<ShopProductsCategory>> fetchShopProductsCategories(
      String shopId) async {
    var url = basic_URL + 'shopProductCategory/?shopId=$shopId';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    // _items.clear();
    // print(responseData);
    // ProductCategories.clearLocalList();
    responseData.forEach((item) {
      addOrderToList(classMapToObj(item));
      // add product category
      ProductCategories.addProductCategoryToLocalList(
          ProductCategories.classMapToObj(item['Product_Category']));
    });
    // print('sixe is: ' + ProductCategories.items.length.toString());
    return items;
  }

  static ShopProductsCategory classMapToObj(Map<String, dynamic> localMap) {
    return ShopProductsCategory(
      id: localMap['id'].toString(),
      shop: localMap['Shop']['id'].toString(),
      productCategory: localMap['Product_Category']['id'].toString(),
      slug: localMap['slug'],
    );
  }

  static void addOrderToList(ShopProductsCategory shopProductsCategory) {
    bool found = false;
    _items.forEach((item) {
      if (item.id == shopProductsCategory.id) {
        found = true;
      }
    });
    if (found == false) {
      _items.add(shopProductsCategory);
    }
  }

  static bool checkShopProductsCategoryByShopId(String shopId) {
    print('ShopProductsCategories _items.length: ${_items.length}');
    bool found = false;
    _items.forEach((item) {
      if (item.shop == shopId) {
        found = true;
      }
    });
    return found;
  }
}

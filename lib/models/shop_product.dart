import 'dart:convert';
import 'package:apna_c3/models/shop_products_category.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';
import './product.dart';
import '../models/product_subcategory.dart';
import '../models/product_unit_type.dart';

class ShopProduct {
  final String id;
  final String product;
  final String shopProductCategory;
  double price;
  final String slug;

  ShopProduct({
    @required this.id,
    @required this.product,
    @required this.shopProductCategory,
    @required this.price,
    @required this.slug,
  });
}

class ShopProducts {
  static List<ShopProduct> _items = [];
  static List<ShopProduct> _itemsList2 = [];

  static List<ShopProduct> get items {
    return [..._items];
  }

  static List<ShopProduct> get itemsList2 {
    return [..._itemsList2];
  }

  static Future<List<ShopProduct>> fetchShopProducts(
      String shopProductsCategoryId) async {
    // print('im in fetch fetchShopProducts');
    var url = basic_URL +
        'shopProduct/?shopProductsCategoryId=$shopProductsCategoryId';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    // _items.clear();
    // Products.clearLocalList();
    // ProductSubcategories.clearLocalList();
    // print(responseData);
    // print('before function');
    responseData.forEach((item) {
      addShopProductAndDependents(item);
    });
    // print('after function');
    // print(items);

    return items;
  }

  static List<ShopProduct> getShopProductsBySubcategory(
      String subcategoryId, String shopId) {
    List<ShopProduct> localList = [];
    // ProductSubcategories.items.forEach(
    //     (productSubcategory) => productSubcategory.id == subcategoryId);
    items.forEach((shopProduct) {
      // shopProduct.s
      ShopProductsCategories.items.forEach((shopProductsCategory) {
        if (shopProductsCategory.id == shopProduct.shopProductCategory &&
            shopProductsCategory.shop == shopId) {
          if (Products.items
                  .firstWhere((product) => product.id == shopProduct.product)
                  .productSubcategory ==
              subcategoryId) {
            localList.add(shopProduct);
          }
        }
      });

      // // shopProduct.shopProductCategory
      // if (Products.items
      //         .firstWhere((product) => product.id == shopProduct.product)
      //         .productSubcategory ==
      //     subcategoryId) {
      //   localList.add(shopProduct);
      // }
    });
    return localList;
  }

  static void addShopProductList(ShopProduct shopProduct) {
    bool founded = false;
    _items.forEach((item) {
      if (item.id == shopProduct.id) {
        founded = true;
      }
    });
    if (founded == false) {
      _items.add(shopProduct);
    }
  }

  static void addShopProductList2(ShopProduct shopProduct) {
    bool founded = false;
    _itemsList2.forEach((item) {
      if (item.id == shopProduct.id) {
        founded = true;
      }
    });
    if (founded == false) {
      _itemsList2.add(shopProduct);
    }
  }

  static ShopProduct classMapToObj(Map<String, dynamic> localMap) {
    return ShopProduct(
      id: localMap['id'].toString(),
      product: localMap['Product']['id'].toString(),
      shopProductCategory: localMap['Shop_Product_Category']['id'].toString(),
      price: double.parse(localMap['Price']),
      slug: localMap['slug'],
    );
  }

  static void addShopProductAndDependents(Map<String, dynamic> localMap) {
    // print('in function');
    // print(localMap);
    addShopProductList(classMapToObj(localMap));

    addShopProductList2(classMapToObj(localMap));

    Products.addProductToLocalList(Products.classMapToObj(localMap['Product']));

    ProductSubcategories.addProductSubcategory(
        ProductSubcategories.classMapToObj(
            localMap['Product']['Product_Subcategory']));

    ProductUnitTypes.addProductUnitType(ProductUnitTypes.classMapToObj(
        localMap['Product']['Product_Unit_Type']));
  }

  static bool findshopProductCategory(String shopProductsCategoryId) {
    bool found = false;
    _items.forEach((item) {
      if (item.shopProductCategory == shopProductsCategoryId) {
        found = true;
      }
    });
    return found;
  }
}

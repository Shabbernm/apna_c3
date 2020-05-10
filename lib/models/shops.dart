import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../providers/conf_data.dart';

class Shop {
  String shopId;
  String shopCategory;
  String name;
  String address;
  String city;
  String location;
  String openingTime;
  String closingTime;
  double minimumOrder;
  double maximumOrder;
  double deliveryCharges;
  String slug;
  String shopStatus;

  Shop({
    @required this.shopId,
    @required this.shopCategory,
    @required this.name,
    @required this.address,
    @required this.city,
    @required this.location,
    @required this.openingTime,
    @required this.closingTime,
    @required this.minimumOrder,
    @required this.maximumOrder,
    @required this.deliveryCharges,
    @required this.slug,
    @required this.shopStatus,
  });
}

class Shops {
  static List<Shop> _items = [];
  static List<Shop> _itemsList2 = [];

  static List<Shop> get items {
    return [..._items];
  }

  static List<Shop> get itemsList2 {
    return [..._itemsList2];
  }

  static Future<List<Shop>> fetchShops() async {
    // print('fetchShops');
    var url = basic_URL + 'allShops/';

    var response = await http.get(url, headers: headers);
    var responseData = json.decode(response.body);

    _items.clear();
    // print('Shabber');
    // print(responseData);
    responseData.forEach((shop) {
      // print(shop['id']);
      var ashop = classMapToObj(shop);
      // Shop(
      //   shopId: shop['id'].toString(),
      //   shopCategory: shop['Shop_Category']['id'].toString(),
      //   name: shop['name'],
      //   address: shop['Address']['address1'],
      //   city: shop['Address']['city']['Name'],
      //   location: shop['Address']['location'],
      //   openingTime: shop['OpeningTime'],
      //   closingTime: shop['ClosingTime'],
      //   minimumOrder: double.parse(shop['MinimumOrder']),
      //   maximumOrder: double.parse(shop['MaximumOrder']),
      //   deliveryCharges: double.parse(shop['DeliveryCharges']),
      //   slug: shop['slug'],
      //   shopStatus: shop['Shop_Status']['Name'],
      // );
      _items.add(ashop);
      addShopList2(ashop);
    });
    // print('List is');
    // print(_items);

    // Map<String, dynamic> data = {};
    // data['shopDetails'] = responseData;
    // if (responseData.length > 0 &&
    //     responseData[0]['Shop_Category']['Name'] == 'Grocery Shop') {
    //   url = basic_URL + 'shopProductCategory/';

    //   response = await http.get(url, headers: headers);
    //   responseData = json.decode(response.body);
    //   data['ShopProductCategories'] = responseData;
    // }

    return items;
  }

  static Future<List<Shop>> fetchShopsByCategoryId(String catId) async {
    var url = basic_URL +
        "getShopsByLocation/?shopCategoryId=$catId&latitude=$conf_latitude&longitude=$conf_longitude&distance=1.5";

    var response = await http.get(url, headers: headers);
    var responseData = json.decode(response.body);
    // _items.clear();
    responseData.forEach((shop) {
      var ashop = classMapToObj(shop);
      addShopList(ashop);
      addShopList2(ashop);
    });
    // print(items);
    return getShopsByShopCategory(catId);
  }

  static void addShopList(Shop passedShop) {
    bool found = false;
    _items.forEach((shop) {
      if (shop.shopId == passedShop.shopId) {
        found = true;
      }
    });
    if (found == false) {
      _items.add(passedShop);
    }
  }

  static void addShopList2(Shop passedShop) {
    bool found = false;
    _itemsList2.forEach((shop) {
      if (shop.shopId == passedShop.shopId) {
        found = true;
      }
    });
    if (found == false) {
      _itemsList2.add(passedShop);
    }
  }

  static Shop classMapToObj(Map<String, dynamic> localMap) {
    return Shop(
      shopId: localMap['id'].toString(),
      shopCategory: localMap['Shop_Category']['id'].toString(),
      name: localMap['name'],
      address: localMap['Address']['address1'],
      city: localMap['Address']['city']['Name'],
      location: localMap['Address']['location'],
      openingTime: localMap['OpeningTime'],
      closingTime: localMap['ClosingTime'],
      minimumOrder: double.parse(localMap['MinimumOrder']),
      maximumOrder: double.parse(localMap['MaximumOrder']),
      deliveryCharges: double.parse(localMap['DeliveryCharges']),
      slug: localMap['slug'],
      shopStatus: localMap['Shop_Status']['Name'],
    );
  }

  static bool findShopCategory(String shopCategoryId) {
    bool found = false;
    _items.forEach((item) {
      if (item.shopCategory == shopCategoryId) {
        found = true;
      }
    });
    return found;
  }

  static List<Shop> getShopsByShopCategory(String shopCategoryId) {
    List<Shop> localList = [];
    _items.forEach((item) {
      if(item.shopCategory == shopCategoryId){
        localList.add(item);
      }
    });
    return localList;
  }
}

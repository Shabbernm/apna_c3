import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../providers/conf_data.dart';
import '../models/order_shop.dart';
import '../models/shop_product.dart';

class OrderShopProduct {
  final String id;
  final String orderShop;
  final String shopProduct;
  final int quantity;
  final double weight;
  final String note;

  OrderShopProduct({
    @required this.id,
    @required this.orderShop,
    @required this.shopProduct,
    @required this.quantity,
    @required this.weight,
    @required this.note,
  });
}

class OrderShopProducts {
  static List<OrderShopProduct> _items = [];

  static List<OrderShopProduct> get items {
    return [..._items];
  }

  static Future<void> fetchOrderShopProducts() async {
    var url = basic_URL + 'orderShopProduct/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((orderShopProduct) {
      addOrderShopProductAndDependents(orderShopProduct);
    });
  }

  static OrderShopProduct classMapToObj(Map<String, dynamic> localMap) {
    return OrderShopProduct(
      id: localMap['id'].toString(),
      orderShop: localMap['Order_Shop']['id'].toString(),
      shopProduct: localMap['Shop_Product']['id'].toString(),
      quantity: localMap['Quantity'],
      weight: double.parse(localMap['Weight']),
      note: localMap['Note'],
    );
  }

  static List<OrderShopProduct> getShopProducts(String orderShopId) {
    // print('orderShopId');
    // print(orderShopId);
    List<OrderShopProduct> localList = [];
    _items.forEach((item) {
      if (item.orderShop == orderShopId) {
        // print(item.orderShop);
        localList.add(item);
      }
    });
    // print(localList);
    return localList;
  }

  static void addOrderShopProductAndDependents(Map<String, dynamic> localMap) {
    _items.add(classMapToObj(localMap));

    // add Order_Shop
    OrderShops.addOrderShopAndDependents(localMap['Order_Shop']);

    // add Shop_Product
    ShopProducts.addShopProductAndDependents(localMap['Shop_Product']);
  }
}

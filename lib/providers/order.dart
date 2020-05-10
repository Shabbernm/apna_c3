import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../providers/conf_data.dart';
import '../models/cart.dart';
import '../models/order_status.dart';
import '../models/user.dart';

class Order {
  final String id;
  final String user;
  final double total;
  final String slug;
  final String orderStatus;
  final String note;

  Order({
    @required this.id,
    @required this.user,
    @required this.total,
    @required this.slug,
    @required this.orderStatus,
    @required this.note,
  });
}

class Orders with ChangeNotifier {
   static List<Order> _items = [];

   List<Order> get items {
    return [..._items];
  }

   Future<void> fetchOrders() async {
    var url = basic_URL + 'order/';
    var response = await http.get(url, headers: headers);
    var responseData = json.decode(response.body);

    _items.clear();
    responseData.forEach((order) {
      _items.add(classMapToObj(order));
    });
  }

  Future<void> fetchDataFromServer() async {
    print('calling fetchOrders Shabber');
    await fetchOrders();
    // await fetchOrderShopProducts();
    notifyListeners();
    Timer(Duration(seconds: 10), fetchDataFromServer);
  }

   Future<int> addOrder() async {
    var url = basic_URL + 'order/';
    var body = json.encode({
      'user': Users.user.id,
      'Total': Carts.cartObj.total,
      'Order_Status':
          OrderStatuses.items.firstWhere((item) => item.name == 'Pending').id,
      'Note': '',
    });
    var responseOrder = await http.post(url, headers: headers, body: body);
    var responseDataOrder = json.decode(responseOrder.body);
    var responseOrderShop, responseOrderShopProduct;
    var responseDataOrderShop, responseDataOrderShopProduct;
    // print(responseDataOrder);
    Carts.cartObj.orderShops.forEach((ordershop) async {
      url = basic_URL + 'orderShop/';
      body = json.encode({
        'Order': responseDataOrder['id'],
        'Shop': ordershop.shopId,
        'Items_Total': ordershop.itemsTotal,
        'DeliveryCharges': 50.0,
        'Note': ordershop.note,
      });
      responseOrderShop = await http.post(url, headers: headers, body: body);
      responseDataOrderShop = json.decode(responseOrderShop.body);
      // print(responseDataOrderShop);

      ordershop.orderShopProducts.forEach((shopproduct) async {
        url = basic_URL + 'orderShopProduct/';
        body = json.encode({
          'Order_Shop': responseDataOrderShop['id'],
          'Shop_Product': shopproduct.shopProduct,
          'Quantity': shopproduct.quantity,
          'Weight': shopproduct.weight,
          'Note': shopproduct.note,
        });
        responseOrderShopProduct =
            await http.post(url, headers: headers, body: body);
        // print(responseOrderShopProduct.body);
        responseDataOrderShopProduct =
            json.decode(responseOrderShopProduct.body);
      });
    });
    return responseDataOrder['id'];
  }

   static void addOrderToList(Order order) {
    bool found = false;
    _items.forEach((item) {
      if (item.id == order.id) {
        found = true;
      }
    });
    if (found == false) {
      _items.add(order);
    }
  }

   static Order classMapToObj(Map<String, dynamic> localMap) {
    return Order(
      id: localMap['id'].toString(),
      user: localMap['user'].toString(),
      total: double.parse(localMap['Total']),
      slug: localMap['slug'],
      orderStatus: localMap['Order_Status'].toString(),
      note: localMap['Note'],
    );
  }
}

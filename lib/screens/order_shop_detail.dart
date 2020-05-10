import 'package:flutter/material.dart';

import '../models/order_shop.dart';
import '../models/order_shop_product.dart';
import '../models/product.dart';
import '../models/shop_product.dart';
import '../models/shops.dart';

class OrderShopDetailScreen extends StatelessWidget {
  static const routeName = '/OrderShopDetailScreen';

  @override
  Widget build(BuildContext context) {
    String orderShopId = ModalRoute.of(context).settings.arguments as String;
    OrderShop orderShop =
        OrderShops.items.firstWhere((item) => item.id == orderShopId);
    List<OrderShopProduct> orderShopProducts =
        OrderShopProducts.getShopProducts(orderShopId);
    // print(orderShopProducts);
    return Scaffold(
      appBar: AppBar(title: Text('Shop Order Detail')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Text(Shops.itemsList2
                    .firstWhere((item) => item.shopId == orderShop.shop)
                    .name),
                Card(
                  child: Column(
                    children: orderShopProducts.map((orderShopProduct) {
                      return ListTile(
                        title: Text(Products.itemsList2
                            .firstWhere((prod) =>
                                prod.id ==
                                ShopProducts.itemsList2
                                    .firstWhere((shopProd) =>
                                        shopProd.id ==
                                        orderShopProduct.shopProduct)
                                    .product)
                            .name),
                        subtitle: Text('Weight or quantity'),
                        trailing: Text('Price'),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text('total order amount: '),
          )
        ],
      ),
    );
  }
}

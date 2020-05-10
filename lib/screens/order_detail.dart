import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../models/order_shop.dart';
import '../models/shops.dart';
import '../screens/order_shop_detail.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = '/OrderDetailScreen';

  @override
  Widget build(BuildContext context) {
    String orderId = ModalRoute.of(context).settings.arguments as String;
    List<OrderShop> orderShops = OrderShops.getOrderShopsByOrder(orderId);
    Order order = Provider.of<Orders>(context, listen: false).items.firstWhere((item) => item.id == orderId);
    int itemCount = 0;
    return Scaffold(
      appBar: AppBar(title: Text('Order Detail')),
      body: ListView(
        children: <Widget>[
          Container(
            child: Text('order Details'),
          ),
          Card(
            child: Column(
              children: orderShops.map((orderShop) {
                itemCount++;
                return Container(
                  decoration: itemCount < orderShops.length
                      ? BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)))
                      : null,
                  child: ListTile(
                    title: Text(Shops.itemsList2
                        .firstWhere((item) => item.shopId == orderShop.shop)
                        .name),
                    subtitle: Text('Number of products'),
                    trailing: Text('Detail'),
                    onTap: () => Navigator.of(context).pushNamed(
                        OrderShopDetailScreen.routeName,
                        arguments: orderShop.id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

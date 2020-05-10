import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../screens/order_detail.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrdersScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Orders')),
      body: Provider.of<Orders>(context).items.length > 0
          ? ListView(
              children: Provider.of<Orders>(context).items.map((order) {
                return Card(
                  child: ListTile(
                    title: Text(order.slug),
                    trailing: Icon(Icons.navigate_next),
                    onTap: (){
                      Navigator.of(context).pushNamed(OrderDetailScreen.routeName, arguments: order.id);
                    },
                  ),
                );
              }).toList(),
            )
          : Center(
              child: Text('You didnt have any orders yet'),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/order_shop.dart';
import '../models/order_shop_product.dart';
import '../providers/order.dart';
import '../screens/orders.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/CheckoutScreen';

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isLoading = false;

  void _placeOrder() async {
    // 1. save order
    // 1. save order
    // 1. save order

    setState(() {
      _isLoading = true;
    });
    int orderId = await Provider.of<Orders>(context, listen: false).addOrder();
    print('Order id is: $orderId');

    await Provider.of<Orders>(context, listen: false).fetchOrders();
    await OrderShops.fetchOrderShops();
    await OrderShopProducts.fetchOrderShopProducts();
    Carts.setCartToBlank();
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed(OrdersScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Text('Order Total'),
                Text('Delivery Charges'),
                Text('Delivery Address'),
                Text('User'),
              ],
            ),
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            RaisedButton(
              child: Text('Place Order'),
              onPressed: _placeOrder,
            ),
        ],
      ),
    );
  }
}

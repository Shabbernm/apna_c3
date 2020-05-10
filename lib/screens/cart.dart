import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../models/shop_product.dart';
import '../models/shops.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_shop_detail.dart';
import '../screens/checkout.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double subTotal = 0.0;
    double deliveryCharges = 50.0;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(
            children: Carts.cartObj.orderShops.map((orderedShop) {
              return Card(
                child: Column(
                  children: <Widget>[
                    Text(Shops.itemsList2
                        .firstWhere((item) => item.shopId == orderedShop.shopId)
                        .name),
                    Column(
                      children: orderedShop.orderShopProducts
                          .map((orderedShopProduct) {
                        subTotal += orderedShopProduct.totalPrice;
                        String prodName = Products.itemsList2
                            .firstWhere((product) =>
                                product.id ==
                                ShopProducts.itemsList2
                                    .firstWhere((item) =>
                                        item.id ==
                                        orderedShopProduct.shopProduct)
                                    .product)
                            .name;
                        return Row(
                          children: <Widget>[
                            Text(prodName),
                            SizedBox(width: 20),
                            Text(orderedShopProduct.quantity.toString() == '0'
                                ? ''
                                : orderedShopProduct.quantity.toString()),
                            SizedBox(width: 20),
                            Text(orderedShopProduct.weight.toString() == '0.0'
                                ? ''
                                : orderedShopProduct.weight.toString()),
                            SizedBox(width: 20),
                            Text(orderedShopProduct.totalPrice.toString()),
                          ],
                        );
                      }).toList(),
                    ),
                    Text('Shop Total: ${orderedShop.itemsTotal}'),
                    RaisedButton(
                      child: Text('Detail'),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(CartShopDetailScreen.routeName, arguments: orderedShop);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Sub Total: $subTotal'),
                  Text('Delivery Charges: $deliveryCharges'),
                  Text('Order Total: ${subTotal + deliveryCharges}'),
                ],
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  child: Text('To Checkout'),
                  onPressed: ()=>Navigator.of(context).pushNamed(CheckoutScreen.routeName),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

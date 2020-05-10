
import 'package:apna_c3/screens/orders.dart';
import 'package:flutter/material.dart';

import '../screens/shop_category_select.dart';
import '../screens/auth_screen.dart';
import '../screens/cart.dart';
// import '../screens/shop.dart';
// import '../screens/category_select.dart';
// import '../screens/product_select.dart';
// import '../models/shop_category.dart';
// import '../models/shops.dart';
// import '../models/shop_products_category.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome to Apna Bazar!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context)
                  .popAndPushNamed(SelectShopCategoryScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(CartScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(SettingsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              // Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}

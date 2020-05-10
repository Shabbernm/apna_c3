import 'package:apna_c3/models/cart.dart';
import 'package:apna_c3/providers/auth.dart';
import 'package:apna_c3/providers/order.dart';
import 'package:apna_c3/screens/cart.dart';
import 'package:apna_c3/screens/cart_shop_detail.dart';
import 'package:apna_c3/screens/checkout.dart';
import 'package:apna_c3/screens/order_detail.dart';
import 'package:apna_c3/screens/order_shop_detail.dart';
import 'package:apna_c3/screens/orders.dart';
import 'package:apna_c3/screens/place_order.dart';
import 'package:apna_c3/screens/product_select.dart';
import 'package:apna_c3/screens/request.dart';
import 'package:apna_c3/screens/shop_category_select.dart';
import 'package:apna_c3/screens/shop_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext ctx) {
    var routes = {
      AuthScreen.routeName: (ctx) => AuthScreen(),
      SelectShopScreen.routeName: (ctx) => SelectShopScreen(),
      SelectProductScreen.routeName: (ctx) => SelectProductScreen(),
      PlaceOrderScreen.routeName: (ctx) => PlaceOrderScreen(),
      CartScreen.routeName: (ctx) => CartScreen(),
      OrderDetailScreen.routeName: (ctx) => OrderDetailScreen(),
      OrderShopDetailScreen.routeName: (ctx) => OrderShopDetailScreen(),
      CartShopDetailScreen.routeName: (ctx) => CartShopDetailScreen(),
      OrdersScreen.routeName: (ctx) => OrdersScreen(),
      CheckoutScreen.routeName: (ctx) => CheckoutScreen(),
      RequestScreen.routeName: (ctx) => RequestScreen(),
      // AddShopScreen.routeName: (ctx) => AddShopScreen(),
    };

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Orders()),
        ChangeNotifierProvider.value(value: Carts()),

        // ChangeNotifierProvider(create: (_) => Auth()),
        // ProxyProvider<Auth, Orders>(
        //   update: (_, counter, __) => Orders(),
        // ),
        // ChangeNotifierProxyProvider<Auth, Orders>(
        //   create: (context) => Orders(),
        //   update: (context, value, previous) => Orders(),
        // ),

      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Apna Bazar',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: auth.isAuth
              ? SelectShopCategoryScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen('Trying auto login')
                          : AuthScreen()),
          routes: routes,
        ),
      ),
    );
  }
}

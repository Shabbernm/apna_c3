import 'package:apna_c3/providers/auth.dart';
import 'package:apna_c3/providers/conf_data.dart';
import 'package:apna_c3/providers/order.dart';
import 'package:apna_c3/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shop_category.dart';
import '../screens/shop_select.dart';
import '../widgets/app_drawer.dart';
import '../models/cart.dart';
import '../screens/cart.dart';

class SelectShopCategoryScreen extends StatelessWidget {
  static const routeName = '/SelectShopCategoryScreen';

  Future<bool> _onBackPressed(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (onceDataIsFetched == false) {
      Provider.of<Orders>(context).fetchDataFromServer();
      // Provider.of<OrderShopProducts>(context).fetchDataFromServer();
    }
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text('Select Category')),
        body: onceDataIsFetched == false
            ? FutureBuilder(
                future: Provider.of<Auth>(context).fetchOnce(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen('Fetching Shop Categories from server')
                        : ShopCategorySelectWidget(),
              )
            : ShopCategorySelectWidget(),
        floatingActionButton: Carts.cartObj.orderShops.length != 0
            ? FloatingActionButton(
                child: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
              )
            : null,
      ),
    );
  }
}

class ShopCategorySelectWidget extends StatefulWidget {
  @override
  _ShopCategorySelectWidgetState createState() =>
      _ShopCategorySelectWidgetState();
}

class _ShopCategorySelectWidgetState extends State<ShopCategorySelectWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? SplashScreen('Getting location')
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: ShopCategories.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GridTile(
                  child: Image.network(ShopCategories.items[i].image,
                      fit: BoxFit.cover),
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(ShopCategories.items[i].name,
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                Navigator.of(context)
                    .pushNamed(SelectShopScreen.routeName, arguments: {
                  'id': ShopCategories.items[i].id,
                });
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          );
  }
}

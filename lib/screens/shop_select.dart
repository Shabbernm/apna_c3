import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/shops.dart';
import '../models/shop_category.dart';
import '../models/cart.dart';
import '../models/shop_products_category.dart';
import '../screens/product_category_select.dart';
import '../screens/product_select.dart';
import '../screens/cart.dart';
import '../providers/conf_data.dart';
import '../screens/request.dart';
import '../screens/splash.dart';

class SelectShopScreen extends StatefulWidget {
  static const routeName = '/SelectShopScreen';

  @override
  _SelectShopScreenState createState() => _SelectShopScreenState();
}

class _SelectShopScreenState extends State<SelectShopScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> passedData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    // if passed shop category is available in data then load data otherwise fetch data
    String shopCategoryName = ShopCategories.items
        .firstWhere((element) => element.id == passedData['id'])
        .name;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select $shopCategoryName'),
      ),
      body: Shops.findShopCategory(passedData['id']) == true
          ? SelectShopWidget(
              Shops.getShopsByShopCategory(passedData['id']), passedData['id'])
          : FutureBuilder(
              future: Shops.fetchShopsByCategoryId(passedData['id']),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SelectShopWidget(snapshot.data, passedData['id']);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
      floatingActionButton: Carts.cartObj.orderShops.length != 0
          ? FloatingActionButton(
              child: Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context).popAndPushNamed(CartScreen.routeName);
              },
            )
          : null,
    );
  }
}

class CartButtonWidget extends StatefulWidget {
  @override
  _CartButtonWidgetState createState() => _CartButtonWidgetState();
}

class _CartButtonWidgetState extends State<CartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class SelectShopWidget extends StatefulWidget {
  final List<Shop> shops;
  final String shopCategoryId;
  SelectShopWidget(this.shops, this.shopCategoryId);

  @override
  _SelectShopWidgetState createState() => _SelectShopWidgetState();
}

class _SelectShopWidgetState extends State<SelectShopWidget> {
  bool _isLoading = false;
  bool _isRequestLoading = false;

  void _requestForService() async {
    // add request to server
    // navigate to
    setState(() {
      _isRequestLoading = true;
    });
    await _addServiceRequest();
    setState(() {
      _isRequestLoading = false;
    });
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(RequestScreen.routeName);
  }

  void _addServiceRequest() async {
    var url = basic_URL + 'serviceRequest/';
    // print('shopCategory');
    // print(shopObj.shopCategory);
    var body = json.encode({
      'location': '${conf_latitude}_$conf_longitude',
      'Note':
          'Request to open a ${ShopCategories.items.firstWhere((element) => element.id == widget.shopCategoryId).name}',
    });
    var response = await http.post(url, headers: headers, body: body);
    var responseData = json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? SplashScreen('Fetching Shop Data')
        : widget.shops.length > 0
            ? ListView(
                children: widget.shops.map<Widget>((shop) {
                return Card(
                    child: ListTile(
                  title: Text(shop.name),
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (ShopCategories.items
                            .firstWhere(
                                (item) => item.id == widget.shopCategoryId)
                            .name ==
                        'Grocery Shop') {
                      Navigator.of(context).pushNamed(
                          SelectProductCategoryScreen.routeName,
                          arguments: shop.shopId);
                    } else {
                      // print('im in else');
                      List<ShopProductsCategory> shopProductCategories =
                          ShopProductsCategories
                                      .checkShopProductsCategoryByShopId(
                                          shop.shopId) ==
                                  true
                              ? ShopProductsCategories.items
                              : await ShopProductsCategories
                                  .fetchShopProductsCategories(shop.shopId);
                      // List<ShopProductsCategory> shopProductCategories =
                      //     await ShopProductsCategories.fetchShopProductsCategories(
                      //         shop.shopId);
                      // print(shopProductCategories);
                      Navigator.of(context)
                          .pushNamed(SelectProductScreen.routeName, arguments: {
                        'shopProductsCategoryId': shopProductCategories
                            .firstWhere((shopProductCategory) =>
                                shopProductCategory.shop == shop.shopId)
                            .id,
                        'shopId': shop.shopId,
                      });
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ));
              }).toList())
            : Center(
                child: Column(
                  children: <Widget>[
                    Text('Request to start this service in your area!'),
                    if (_isRequestLoading == true)
                      CircularProgressIndicator()
                    else
                      RaisedButton(
                        child: Text('Request Now'),
                        onPressed: _requestForService,
                      )
                  ],
                ),
              );
  }
}

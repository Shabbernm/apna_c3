import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../models/product_subcategory.dart';
import '../models/shop_product.dart';
import '../models/product_unit_type.dart';
import '../screens/cart.dart';
import '../screens/place_order.dart';

class SelectProductScreen extends StatefulWidget {
  static const routeName = '/SelectProductScreen';

  @override
  _SelectProductScreenState createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> passedData =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    // if passed shopProductsCategoryId is available in data then load data otherwise fetch data
    ShopProducts.findshopProductCategory(passedData['shopProductsCategoryId']);

    return ShopProducts.findshopProductCategory(passedData['shopProductsCategoryId']) == true
        ? SelectProductWidget(passedData['shopId'])
        : FutureBuilder(
            future: ShopProducts.fetchShopProducts(passedData['shopProductsCategoryId']),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SelectProductWidget(passedData['shopId']);
              } else {
                return CircularProgressIndicator();
              }
            },
          );
  }
}

class SelectProductWidget extends StatefulWidget {
  final String shopId;
  SelectProductWidget(this.shopId);

  @override
  _SelectProductWidgetState createState() => _SelectProductWidgetState();
}

class _SelectProductWidgetState extends State<SelectProductWidget> {
  @override
  Widget build(BuildContext context) {
    List<ProductSubcategory> productSubcategories =
        ProductSubcategories.getProductSubcategoriesByShopId(
            widget.shopId);
    return DefaultTabController(
      length: productSubcategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Product'),
          bottom: TabBar(
            tabs: productSubcategories.map((subcategory) {
              return Tab(
                child: Text(subcategory.name),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
            children: productSubcategories.map((subcategory) {
          var shopProductList =
              ShopProducts.getShopProductsBySubcategory(subcategory.id, widget.shopId);
          return ListView.builder(
            itemCount: shopProductList.length,
            itemBuilder: (ctx, i) {
              return ListTile(
                leading: Image.network(Products.items
                    .firstWhere((prod) => prod.id == shopProductList[i].product)
                    .image),
                title: Text(Products.items
                    .firstWhere(
                        (product) => product.id == shopProductList[i].product)
                    .name),
                subtitle: Text(shopProductList[i].price.toString()),
                trailing: Icon(Icons.navigate_next),
                onTap: () async {
                  // print('Add item/product to cart');
                  String prodUnitType = ProductUnitTypes.items
                      .firstWhere((productUnitType) =>
                          productUnitType.id ==
                          Products.items
                              .firstWhere((product) =>
                                  product.id == shopProductList[i].product)
                              .productUnitType)
                      .name;
                  if (prodUnitType == 'By Quantity') {
                    Carts.addProductInCart(shopProductList[i]);
                  } else if (prodUnitType == 'By Weight') {
                    // go to place order page
                    Navigator.of(context).pushNamed(PlaceOrderScreen.routeName,
                        arguments: shopProductList[i]);

                    // bool check;
                    // do {
                    //   check = await _selectQuantity(
                    //       context, shopProductList[i]);
                    // } while (check == true);
                  } else {
                    print('Wrong unit type: ' + prodUnitType);
                  }
                },
              );
            },
          );
        }).toList()),
        floatingActionButton: Carts.cartObj.orderShops.length != 0
            ? FloatingActionButton(
                child: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popAndPushNamed(CartScreen.routeName);
                },
              )
            : null,
      ),
    );
  }
}

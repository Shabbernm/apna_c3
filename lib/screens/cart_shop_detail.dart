import 'package:apna_c3/models/cart.dart';
import 'package:apna_c3/models/product.dart';
import 'package:apna_c3/models/product_unit_type.dart';
import 'package:apna_c3/models/shop_category.dart';
import 'package:apna_c3/models/shop_product.dart';
import 'package:apna_c3/models/shop_products_category.dart';
import 'package:apna_c3/models/shops.dart';
import 'package:apna_c3/providers/order.dart';
import 'package:apna_c3/screens/product_category_select.dart';
import 'package:apna_c3/screens/product_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartShopDetailScreen extends StatelessWidget {
  static const routeName = '/CartShopDetailScreen';

  @override
  Widget build(BuildContext context) {
    OrderShop orderedShop =
        ModalRoute.of(context).settings.arguments as OrderShop;
    Shop shop = Shops.itemsList2
        .firstWhere((item) => item.shopId == orderedShop.shopId);
    return Scaffold(
      appBar: AppBar(title: Text('Shop - ${shop.name}')),
      body: Card(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children:
                    orderedShop.orderShopProducts.map((orderedShopProduct) {
                  ShopProduct shopProduct = ShopProducts.itemsList2.firstWhere(
                      (item) => item.id == orderedShopProduct.shopProduct);
                  String prodName = Products.itemsList2
                      .firstWhere(
                          (product) => product.id == shopProduct.product)
                      .name;

                  String prodUnitType = ProductUnitTypes.items
                      .firstWhere((productUnitType) =>
                          productUnitType.id ==
                          Products.items
                              .firstWhere((product) =>
                                  product.id ==
                                  ShopProducts.items
                                      .firstWhere((element) =>
                                          element.id ==
                                          orderedShopProduct.shopProduct)
                                      .product)
                              .productUnitType)
                      .name;
                  return Row(
                    children: <Widget>[
                      Text(prodName),
                      SizedBox(width: 20),
                      // if (prodUnitType == 'By Quantity')
                      // Text(orderedShopProduct.quantity.toString() == '0'
                      //     ? ''
                      //     : orderedShopProduct.quantity.toString()),
                      // SizedBox(width: 20),
                      // if (prodUnitType == 'By Weight')
                      //   Text(orderedShopProduct.weight.toString() == '0.0'
                      //       ? ''
                      //       : orderedShopProduct.weight.toString()),
                      // SizedBox(width: 20),
                      Text(orderedShopProduct.totalPrice.toString()),
                      SizedBox(width: 20),
                      if (prodUnitType == 'By Quantity')
                        Container(
                          child: Row(
                            children: <Widget>[
                              if (orderedShopProduct.quantity == 1)
                                IconButton(
                                  icon: Icon(Icons.delete_outline),
                                  onPressed: () => Carts.deleteProductInCart(
                                      orderedShopProduct, shop.shopId),
                                )
                              else
                                IconButton(
                                  icon: Icon(Icons.minimize),
                                  onPressed: () => Carts.decrementProductInCart(
                                      shop.shopId, shopProduct.id),
                                ),
                              Text(orderedShopProduct.quantity.toString()),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => Carts.incrementProductInCart(
                                    shop.shopId, shopProduct.id),
                              ),
                            ],
                          ),
                        )
                      else
                        Row(
                          children: <Widget>[
                            Text('${orderedShopProduct.weight.toString()} Kg'),
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () => Carts.deleteProductInCart(
                                  orderedShopProduct, shop.shopId),
                            )
                          ],
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            Text('Shop Total: ${orderedShop.itemsTotal}'),
            RaisedButton(
              child: Text('Add Order from ${shop.name}'),
              onPressed: () {
                if (ShopCategories.items
                        .firstWhere((item) => item.id == shop.shopCategory)
                        .name ==
                    'Grocery Shop') {
                  Navigator.of(context).pushNamed(
                      SelectProductCategoryScreen.routeName,
                      arguments: shop.shopId);
                } else {
                  String shopProductsCategoryId = ShopProductsCategories.items
                      .firstWhere((shopProductsCategory) =>
                          shopProductsCategory.shop == shop.shopId)
                      .id;

                  var arguments = {
                    'shopProductsCategoryId': shopProductsCategoryId,
                    'shopId': shop.shopId,
                  };

                  Navigator.of(context).pushNamed(SelectProductScreen.routeName,
                      arguments: arguments);
                }
              },
              // onPressed: null,
            )
          ],
        ),
      ),
    );
  }
}

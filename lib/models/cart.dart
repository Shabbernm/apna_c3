import 'package:flutter/foundation.dart';

import '../models/shop_product.dart';
import '../models/shop_products_category.dart';

class OrderShopProduct {
  final String shopProduct;
  int quantity;
  final double weight;
  final String note;
  double totalPrice;
  double productPrice;

  OrderShopProduct({
    @required this.shopProduct,
    this.quantity,
    this.weight,
    this.note,
    @required this.totalPrice,
    @required this.productPrice,
  });
}

class OrderShop {
  final String shopId;
  double itemsTotal;
  final String note;
  List<OrderShopProduct> orderShopProducts;

  OrderShop({
    @required this.shopId,
    @required this.itemsTotal,
    this.note,
    this.orderShopProducts,
  });
}

class Cart {
  final String user = '';
  final double total = 0;
  List<OrderShop> orderShops = [];
}

class Carts with ChangeNotifier {
  static Cart cartObj = Cart();

  static void addProductInCart(ShopProduct shopProduct) {
    String shopId = ShopProductsCategories.items
        .firstWhere((shopProductsCategories) =>
            shopProductsCategories.id == shopProduct.shopProductCategory)
        .shop;
    double price = ShopProducts.items
        .firstWhere((item) => item.id == shopProduct.id)
        .price;
    bool added = false;
    cartObj.orderShops.forEach((orderedShop) {
      if (orderedShop.shopId == shopId) {
        bool updated = false;
        orderedShop.orderShopProducts.forEach((item) {
          if (item.shopProduct == shopProduct.id) {
            item.quantity += 1;
            item.productPrice = item.quantity * price;
            // print('updated' + shopProduct.id);
            updated = true;
          }
        });
        if (updated == false) {
          orderedShop.orderShopProducts.add(OrderShopProduct(
            shopProduct: shopProduct.id,
            quantity: 1,
            weight: 0.0,
            note: '',
            totalPrice: price,
            productPrice: price,
          ));
          // print('Added' + shopProduct.id);
        }

        // update shop total
        double shopTotal = 0.0;
        orderedShop.orderShopProducts.forEach((shopProd) {
          shopTotal += shopProd.totalPrice;
        });
        orderedShop.itemsTotal = shopTotal;
        added = true;
      }
    });
    if (added == false) {
      //add shop first then add product
      cartObj.orderShops.add(OrderShop(
          shopId: shopId,
          itemsTotal: price,
          note: '',
          orderShopProducts: [
            OrderShopProduct(
              shopProduct: shopProduct.id,
              quantity: 1,
              weight: 0.0,
              note: '',
              totalPrice: price,
              productPrice: price,
            ),
          ]));
      // print('new shop and product Added' + shopProduct.id);
    }
  }

  static void addProductInCartByWeight(
      ShopProduct shopProduct, double weight, String productNote) {
    // print('save a product by weight and update its prices');
    // print(weight);
    // print(productNote);

    String shopId = ShopProductsCategories.items
        .firstWhere((shopProductsCategories) =>
            shopProductsCategories.id == shopProduct.shopProductCategory)
        .shop;

    double price = ShopProducts.items
        .firstWhere((item) => item.id == shopProduct.id)
        .price;

    bool added = false;
    cartObj.orderShops.forEach((orderedShop) {
      if (orderedShop.shopId == shopId) {
        orderedShop.orderShopProducts.add(OrderShopProduct(
          shopProduct: shopProduct.id,
          quantity: 0,
          weight: weight,
          note: productNote,
          totalPrice: weight * price,
          productPrice: price,
        ));
        print('Added to existing shop: ' + shopId);

        // update shop total
        double shopTotal = 0.0;
        orderedShop.orderShopProducts.forEach((shopProd) {
          shopTotal += shopProd.totalPrice;
        });
        orderedShop.itemsTotal = shopTotal;

        added = true;
      }
    });
    if (added == false) {
      //add shop first then add product
      cartObj.orderShops.add(OrderShop(
          shopId: shopId,
          itemsTotal: weight * price,
          note: '',
          orderShopProducts: [
            OrderShopProduct(
              shopProduct: shopProduct.id,
              quantity: 0,
              weight: weight,
              note: productNote,
              totalPrice: weight * price,
              productPrice: price,
            ),
          ]));
      print('new shop and product Added: ' + shopId);
    }
  }

  static void addProductInCartByPrice(
      ShopProduct shopProduct, double passedPrice, String productNote) {
    String shopId = ShopProductsCategories.items
        .firstWhere((shopProductsCategories) =>
            shopProductsCategories.id == shopProduct.shopProductCategory)
        .shop;

    bool added = false;
    cartObj.orderShops.forEach((orderedShop) {
      if (orderedShop.shopId == shopId) {
        double price = ShopProducts.items
            .firstWhere((item) => item.id == shopProduct.id)
            .price;
        orderedShop.orderShopProducts.add(OrderShopProduct(
          shopProduct: shopProduct.id,
          quantity: 1,
          weight: 0,
          note: productNote,
          totalPrice: passedPrice,
          productPrice: price,
        ));
        // print('Added' + shopProduct.id);

        // update shop total
        double shopTotal = 0.0;
        orderedShop.orderShopProducts.forEach((shopProd) {
          shopTotal += shopProd.totalPrice;
        });
        orderedShop.itemsTotal = shopTotal;

        added = true;
      }
    });
    if (added == false) {
      //add shop first then add product
      double price = ShopProducts.items
          .firstWhere((item) => item.id == shopProduct.id)
          .price;
      cartObj.orderShops.add(OrderShop(
          shopId: shopId,
          itemsTotal: passedPrice,
          note: '',
          orderShopProducts: [
            OrderShopProduct(
              shopProduct: shopProduct.id,
              quantity: 1,
              weight: 0,
              note: productNote,
              totalPrice: passedPrice,
              productPrice: price,
            ),
          ]));
      // print('new shop and product Added' + shopProduct.id);
    }
  }

  static void setCartToBlank() {
    cartObj = Cart();
  }

  static void incrementProductInCart(String shopId, String shopProductId) {
    OrderShop orderShop =
        cartObj.orderShops.firstWhere((element) => element.shopId == shopId);
    OrderShopProduct orderShopProduct = orderShop.orderShopProducts
        .firstWhere((element) => element.shopProduct == shopProductId);
    orderShopProduct.quantity += 1;
    orderShopProduct.totalPrice += orderShopProduct.productPrice;
    orderShop.itemsTotal += orderShopProduct.productPrice;
    // notifyListeners();
  }

  static void decrementProductInCart(String shopId, String shopProductId) {
    OrderShop orderShop =
        cartObj.orderShops.firstWhere((element) => element.shopId == shopId);
    OrderShopProduct orderShopProduct = orderShop.orderShopProducts
        .firstWhere((element) => element.shopProduct == shopProductId);
    orderShopProduct.quantity -= 1;
    orderShopProduct.totalPrice -= orderShopProduct.productPrice;
    orderShop.itemsTotal -= orderShopProduct.productPrice;

    // cartObj.orderShops
    //     .firstWhere((element) => element.shopId == shopId)
    //     .orderShopProducts
    //     .firstWhere((element) => element.shopProduct == shopProductId)
    //     .quantity -= 1;
    // notifyListeners();
  }

  static void deleteProductInCart(
      OrderShopProduct orderedShopProduct, String shopId) {
    OrderShop orderShop =
        cartObj.orderShops.firstWhere((element) => element.shopId == shopId);

    orderShop.orderShopProducts.remove(orderedShopProduct);
    // orderShop.itemsTotal=
    orderShop.itemsTotal-=orderedShopProduct.totalPrice;
    // orderShop.orderShopProducts.forEach((element) { 
    //   element.
    // });

    // .firstWhere((element) => element.shopProduct == shopProductId)
    // .quantity -= 1;
    // notifyListeners();
  }
}

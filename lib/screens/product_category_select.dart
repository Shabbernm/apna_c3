import 'package:flutter/material.dart';

import '../models/shop_products_category.dart';
import '../models/product_category.dart';
import '../models/shop_category.dart';
import '../screens/product_select.dart';

class SelectProductCategoryScreen extends StatelessWidget {
  static const routeName = '/SelectProductCategoryScreen';

  @override
  Widget build(BuildContext context) {
    String shopId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('Select Category')),
      body: FutureBuilder(
        future: ShopProductsCategories.fetchShopProductsCategories(shopId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: ShopProductsCategories.items.length,
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
              child: Image.network(ProductCategories.items.firstWhere((shopCategory)=>shopCategory.id==ShopProductsCategories.items[i].productCategory).image,
                  fit: BoxFit.cover),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(ProductCategories.items.firstWhere((shopCategory)=>shopCategory.id==ShopProductsCategories.items[i].productCategory).name,
                    textAlign: TextAlign.center),
              ),
            ),
          ),
          onTap: () {
            // pass shop category id 
            Navigator.of(context).pushNamed(SelectProductScreen.routeName, arguments: ShopProductsCategories.items[i].id);
          },
        ),
      );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

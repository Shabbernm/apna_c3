import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/product_subcategory.dart';
import '../models/shop_product.dart';
import '../models/shop_products_category.dart';

class PlaceOrderScreen extends StatefulWidget {
  static const routeName = '/PlaceOrderScreen';

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  ShopProduct shopProduct;
  final _formKey = GlobalKey<FormState>();
  String productNote = '';
  double productPrice = 0.0;
  final _productNoteFocusNode = FocusNode();
  bool _isLoading = false;
  Map<String, bool> weights = {
    '100 Grams': false,
    '250 Grams': false,
    '500 Grams': false,
    '1.0 Kg': false,
    '1.5 Kg': false,
    '2.0 Kg': false,
    '2.5 Kg': false,
    '3.0 Kg': false,
    '3.5 Kg': false,
    '4.0 Kg': false,
    '5.0 Kg': false,
  };
  Map<String, bool> chickenSides = {
    'Any': false,
    'Leg': false,
    'Chest': false,
  };
  Map<String, bool> beefOrMuttonSides = {
    'Any': false,
    'Raan': false,
    'Puth': false,
    'Qamar': false,
    'Karian': false,
  };

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    shopProduct = ModalRoute.of(context).settings.arguments as ShopProduct;
    setListToFalse(weights);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _productNoteFocusNode.dispose();
    super.dispose();
  }

  void _showErrorDialog(BuildContext context, String message) {
      print('selectedMeatSide: $message');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _saveData() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    String prodyctCategory = ProductCategories.items
        .firstWhere((prodCat) =>
            prodCat.id ==
            ShopProductsCategories.items
                .firstWhere((cat) => cat.id == shopProduct.shopProductCategory)
                .productCategory)
        .name;
    if (prodyctCategory == 'Milk Shop Category') {
      validateMilkShop(shopProduct);
    } else if (prodyctCategory == 'Meat Shop Category') {
      validateMeatShop(shopProduct);
    } else if (prodyctCategory == 'Sabzi Store Category') {
      validateSabziShop(shopProduct);
    }

    setState(() {
      _isLoading = false;
    });
    // Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  Widget _makeList(Map<String, bool> localList) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: localList.keys.map((weight) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: localList[weight] == true ? Colors.green : Colors.blue,
                  child: Padding(
                      padding: EdgeInsets.all(10.0), child: Text(weight)),
                )),
            onTap: () {
              setListToFalse(localList);
              setState(() {
                localList[weight] = !localList[weight];
              });
              print('Changed State to ' + localList[weight].toString());
            },
          ),
        );
      }).toList(),
    );
  }

  void setListToFalse(Map<String, bool> localList) {
    localList.keys.forEach((item) {
      localList[item] = false;
    });
  }

  dynamic checkSelectedInList(Map<String, bool> localList) {
    bool anySelectedItem = false;
    String selectedItem = '';
    localList.keys.forEach((weight) {
      if (localList[weight] == true) {
        anySelectedItem = true;
        selectedItem = weight;
      }
    });
    if (anySelectedItem == true) {
      return selectedItem;
    }
    return anySelectedItem;
  }

  @override
  Widget build(BuildContext context) {
    // print('Shabber');
    // print(ProductCategories.items);
    // print(ShopProductsCategories.items);
    // String nameS= ProductCategories.items
    //                       .firstWhere((prodCategory) =>
    //                           prodCategory.id ==
    //                           ShopProductsCategories.items
    //                               .firstWhere((item) =>
    //                                   item.id ==
    //                                   shopProduct.shopProductCategory)
    //                               .productCategory)
    //                       .name;
    // print('nameS: $nameS');

    String prodName = Products.itemsList2
        .firstWhere((prod) => prod.id == shopProduct.product)
        .name;
    String shopCategoryName = ProductCategories.items
        .firstWhere((prodCategory) =>
            prodCategory.id ==
            ShopProductsCategories.items
                .firstWhere(
                    (item) => item.id == shopProduct.shopProductCategory)
                .productCategory)
        .name;
    String productSubcategoryName = ProductSubcategories.items
        .firstWhere((subcat) =>
            subcat.id ==
            Products.itemsList2
                .firstWhere((prod) => prod.id == shopProduct.product)
                .productSubcategory)
        .name;
    return Scaffold(
      appBar: AppBar(title: Text('Place Order')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Text(prodName),
                  Text('Price: ${shopProduct.price}'),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text('Select Weight'),
                  SizedBox(
                    height: 40.0,
                    child: _makeList(weights),
                  ),
                  if (shopCategoryName == 'Meat Shop Category')
                    Column(
                      children: <Widget>[
                        Text('Select meat side'),
                        SizedBox(
                          height: 40.0,
                          child: productSubcategoryName == 'Beef' ||
                                  productSubcategoryName == 'Mutton'
                              ? _makeList(beefOrMuttonSides)
                              : _makeList(chickenSides),
                        ),
                      ],
                    ),
                  if (shopCategoryName == 'Sabzi Store Category')
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Write price'),
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_productNoteFocusNode);
                      },
                      validator: (value) {
                        //if value is empty and none item is selected in the list raise error
                        if (value.isEmpty &&
                            checkSelectedInList(weights) == false) {
                          // error dialog
                          _showErrorDialog(context, 'Select weight or write price!');
                          return 'Enter price';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value.isEmpty) {
                          productPrice = 0;
                        } else {
                          productPrice = double.parse(value);
                        }
                      },
                    ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Write order'),
                    keyboardType: TextInputType.multiline,
                    focusNode: _productNoteFocusNode,
                    maxLines: 3,
                    onSaved: (value) {
                      productNote = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            RaisedButton(
              child: Text('Add to Cart'),
              onPressed: _saveData,
            ),
        ],
      ),
    );
  }

  double getSelectedWeight() {
    var weightInString =
        weights.keys.firstWhere((weightKey) => weights[weightKey] == true);
    // print('weightInString');
    // print(weightInString);
    if (weightInString == '100 Grams') {
      return 0.1;
    } else if (weightInString == '250 Grams') {
      return 0.25;
    } else if (weightInString == '500 Grams') {
      return 0.5;
    } else if (weightInString == '1.0 Kg') {
      return 1.0;
    } else if (weightInString == '1.5 Kg') {
      return 1.5;
    } else if (weightInString == '2.0 Kg') {
      return 2.0;
    } else if (weightInString == '2.5 Kg') {
      return 2.5;
    } else if (weightInString == '3.0 Kg') {
      return 3.0;
    } else if (weightInString == '3.5 Kg') {
      return 3.5;
    } else if (weightInString == '4.0 Kg') {
      return 4.0;
    } else if (weightInString == '5.0 Kg') {
      return 5.0;
    } else {
      print('No weight in String is found so returning null');
      return null;
    }
  }

  void validateMilkShop(ShopProduct shopProduct) {
    // must validate weight
    // pass weight, note
    dynamic selectedWeight = checkSelectedInList(weights);
    if (selectedWeight != false) {
      _formKey.currentState.save();

      Carts.addProductInCartByWeight(
          shopProduct, getSelectedWeight(), productNote);

      print('add milk product to cart: ' + selectedWeight);
      // getSelectedWeight();
    } else {
      print('No weihgt is selected');
      _showErrorDialog(context, 'No weihgt is selected');
    }
  }

  void validateMeatShop(ShopProduct shopProduct) {
    // must validate weight
    // validate chicken or beef list
    // pass weight, note
    dynamic selectedWeight = checkSelectedInList(weights);
    dynamic selectedMeatSide;
    if (ProductSubcategories.items
                .firstWhere((subcat) =>
                    subcat.id ==
                    Products.itemsList2
                        .firstWhere((prod) => prod.id == shopProduct.product)
                        .productSubcategory)
                .name ==
            'Beef' ||
        ProductSubcategories.items
                .firstWhere((subcat) =>
                    subcat.id ==
                    Products.itemsList2
                        .firstWhere((prod) => prod.id == shopProduct.product)
                        .productSubcategory)
                .name ==
            'Mutton') {
      // check beef or mutton list
      selectedMeatSide = checkSelectedInList(beefOrMuttonSides);
    } else if (ProductSubcategories.items
            .firstWhere((subcat) =>
                subcat.id ==
                Products.itemsList2
                    .firstWhere((prod) => prod.id == shopProduct.product)
                    .productSubcategory)
            .name ==
        'Chicken') {
      // check chicken list
      selectedMeatSide = checkSelectedInList(chickenSides);
    }
    if (selectedMeatSide == false) {
      print('selectedMeatSide: $selectedMeatSide');
      _showErrorDialog(context, 'No meat side is selected');
    } else if (selectedWeight == false) {
      _showErrorDialog(context, 'No weight is selected');
    } else if (selectedMeatSide != false && selectedWeight != false) {
      // add by weight and pass weight and note
      _formKey.currentState.save();
      productNote = 'Side: $selectedMeatSide, Note: $productNote';

      Carts.addProductInCartByWeight(
          shopProduct, getSelectedWeight(), productNote);
      print('add meat product to cart: ' + productNote);
    }
  }

  void validateSabziShop(ShopProduct shopProduct) {
    // validate weight or price
    // pass weight or price and note
    dynamic selectedWeight = checkSelectedInList(weights);
    if (selectedWeight != false) {
      // add by weight
      _formKey.currentState.save();
      print('add sabzi by weight to cart: ' + selectedWeight);

      Carts.addProductInCartByWeight(
          shopProduct, getSelectedWeight(), productNote);
    } else {
      _formKey.currentState.save();
      // add by price
      print('add sabzi by price to cart: ' + productPrice.toString());
      Carts.addProductInCartByPrice(shopProduct, productPrice, productNote);
    }
  }
}

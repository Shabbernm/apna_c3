import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

import './conf_data.dart';
import '../exceptions/http_exception.dart';
import '../exceptions/success_exception.dart';
import '../screens/shop_category_select.dart';
import '../models/shop_category.dart';
import '../models/shops.dart';
import '../models/order_status.dart';
import '../models/user.dart';
import '../models/order_shop_product.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  bool firstTime = false;

  bool get isAuth {
    bool check = token != null;
    if (check) {
      // set token
      conf_token = token;
    }
    return check;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get authToken {
    return _token;
  }

  Future<void> signup(String email, String password) async {
    var url = basic_URL + 'signup/';
    const url2 =
        "https://api.darksky.net/forecast/3c86c7d5b041f9cfda364001b1dcfce8/37.8267,-122.4233";
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'email': email,
            'password': password,
            'user_type': 'shop',
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      print(responseData['id']);
      if (responseData['email'][0] == 'user with this email already exists.') {
        print('in signup email');
        throw HttpException(responseData['email'][0]);
      }
      if (responseData['password'] != null) {
        print('in signup password');
        throw HttpException(responseData['password'][0]);
      }
      if (responseData['id'] != null) {
        print('in signup id');
        throw SuccessException('Created Sucessfully');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    var url = basic_URL + 'login/';
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            // 'email': email,
            // 'password': password,
            'email': 's@s.com',
            'password': 'shabber5',
          }));
      final responseData = json.decode(response.body);
      // print(responseData);
      if (responseData['non_field_errors'] != null) {
        throw HttpException(responseData['non_field_errors'][0]);
      }
      _token = responseData['token'];
      conf_token = _token;
      // _userId get from 'me' link
      _expiryDate = DateTime.now().add(Duration(hours: 1));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
      // print('at end');
      // print(_token);
      // fetchDataFromServerAfterSomeTime();
      // await fetchDataFromServer();
      // Navigator.of(ctx).popAndPushNamed(SelectShopCategoryScreen.routeName);
    } catch (error) {
      throw error;
    }
  }

  Future<void> callMe() async {
    const url = 'https://www.shabber.tech/me/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    print('responseData');
    print(responseData['id']);
  }

  Future<bool> tryAutoLogin() async {
    print('tryAutoLogin called');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    conf_token = _token;
    notifyListeners();
    _autoLogout();
    print('tryAutoLogin called2');
    // Navigator.of(ctx).pushNamed(DashboardScreen.routeName);
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    conf_token = '';
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    // notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> fetchOnce() async {
    onceDataIsFetched = true;
    getAndSaveLocation();
    await ShopCategories.fetchShopCategories();
    Users.fetchUser();
    OrderStatuses.fetchOrderStatuses();
  }

  void getAndSaveLocation() async {
    final locData = await Location().getLocation();
    conf_latitude = locData.latitude;
    conf_longitude = locData.longitude;
  }

  void fetchDataFromServer() async {
    // print('Data is fetching');
    await ShopCategories.fetchShopCategories();
    Shops.fetchShops();
    Users.fetchUser();
    OrderStatuses.fetchOrderStatuses();
    // ProductCategories.fe
    // Orders.fetchOrders();
    // OrderShops.fetchOrderShops();
    OrderShopProducts.fetchOrderShopProducts();
  }

  void fetchDataFromServerAfterSomeTime() async {
    // print('im in fetchDataFromServerAfterSomeTime');

    if (firstTime == true) {
      // get data and notifylisteners
      print('its my second time');
    } else {
      print('its my first time');
      await fetchDataFromServer();
      // print('after calling fetchData');
      // Navigator.of(context).popAndPushNamed(SelectShopCategoryScreen.routeName);
    }
    firstTime = true;
    Timer(Duration(seconds: 60), fetchDataFromServerAfterSomeTime);
  }
}

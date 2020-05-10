import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class User {
  final String id;
  final String email;
  final String userType;
  final String slug;
  User({
    @required this.id,
    @required this.email,
    @required this.userType,
    @required this.slug,
  });
}

class Users {
  static User _user;

  static User get user {
    return _user;
  }

  static Future<void> fetchUser() async {
    var url = basic_URL + 'me/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _user = User(
      id: responseData['id'].toString(),
      email: responseData['email'],
      userType: responseData['user_type'],
      slug: responseData['slug'],
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/config.dart';
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  int? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  int? get userId {
    return _userId;
  }

  Future<void> signup(
    String email,
    String username,
    String password,
  ) async {
    final url = Uri.parse("$mainApiUrl/user");

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "username": username,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(response.statusCode, responseData['error']);
      }
      await login(username, password);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String username, String password) async {
    final url = Uri.parse("$mainApiUrl/user/login");

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "username": username,
            "password": password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(response.statusCode, responseData['error']);
      }
      _token = responseData['access_token'];
      _userId = responseData['user']['user_id'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          "token": _token,
          "userID": _userId,
        },
      );
      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString("userData")!) as Map<String, dynamic>;

    _token = extractedUserData["token"] as String;
    _userId = extractedUserData["userID"] as int;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
    prefs.clear();
    notifyListeners();
  }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer!.cancel();
  //   }
  //   final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry!), () {
  //     logout();
  //   });
  // }
}

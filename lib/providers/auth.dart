import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTImer;

  bool get isAuth {
    return !(token == null);
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId {
    if (_token != null) {
      return _userId;
    }
    return null;
  }

  final api1 = "AIzaSyAvVibt6BUjNDP52S1YWacGm3N30pxXYdI";
  final api2 = "AIzaSyC13spCwP_f_SalxEbkB-wjedoF8iYENlQ";
  Future<void> _authenticate(
      String email, String password, String signingSegment) async {
    final url = Uri.parse(
        "https://www.googleapis.com/identitytoolkit/v3/relyingparty/$signingSegment?key=$api1");
    try {
      final response = await http.post(url,
          // this has a 200 status, but it may have a response body that contains an error
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);

      if (responseData["error"] != null) {
        debugPrint(responseData.toString());
        throw HttpException(responseData["error"]["message"]);
      }

      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String()
      });
      prefs.setString("userData", userData);
    } catch (e) {
      // firebase direct error, but not error related to our email error
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "verifyPassword");
  }

  Future<void> signup(String email, String password) {
    return _authenticate(email, password, "signupNewUser");
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTImer != null) {
      _authTImer!.cancel();
      _authTImer = null;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("userData");
    } catch (e) {
      debugPrint("userData has not been defined.");
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTImer != null) {
      _authTImer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTImer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> successAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final recoveredData = json.decode(prefs.getString("userData")!);
    final expiryDate = DateTime.parse(recoveredData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = recoveredData["token"];
    _userId = recoveredData["userId"];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    return true;
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

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
      notifyListeners();
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
}

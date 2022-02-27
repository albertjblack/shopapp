import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './../models/http_exception.dart';

class Product with ChangeNotifier {
  final String? id; // final cuz we expect to get it when product gets created
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool?
      isFavorite; // not final because it can change after the product creation

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite() async {
    try {
      final url = Uri.https("flutter-shop-v1-default-rtdb.firebaseio.com",
          "/products/${id!}.json");
      final response = await http.patch(url,
          body: json.encode({"isFavorite": !isFavorite!}));
      if (response.statusCode >= 400) {
        throw HttpException("Failed to toggle favorite, please try again.");
      }
      isFavorite = !isFavorite!;
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}

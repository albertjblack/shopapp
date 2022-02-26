import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import './../models/http_exception.dart';

// we only want to change data from within, so notifyListeners let know all the other part that are listening
class ProductsProvider with ChangeNotifier {
  // changenotifier allows us to establish behind the scenes comunications with the help of context
  // we do not want to edit _items when product change
  // we want to call a method to update the _items with listeners
  List<Product> _items = [];

  // since the _items is private we need to add a getter
  List<Product> get items {
    // we return a copy of _items
    // if we returned the _items list then it would return a pointer to _items
    // we don't want to directly edit because we would not be able to call notifyListeners
    return [..._items];
  }

  List<Product> get favs {
    return _items.where((e) => e.isFavorite == true).toList();
  }

  Future addProduct(String _action, Product _product) async {
    final url = Uri.https(
        "flutter-shop-v1-default-rtdb.firebaseio.com", "/products.json");
    if (_action == "add") {
      try {
        // req
        final response = await http.post(url,
            body: json.encode({
              "title": _product.title,
              "description": _product.description,
              "price": _product.price,
              "imageUrl": _product.imageUrl,
              "isFavorite": _product.isFavorite,
            }));
        // local
        String _id = json.decode(response.body)["name"];
        _items.insert(
            0,
            Product(
              id: _id,
              title: _product.title,
              description: _product.description,
              price: _product.price,
              imageUrl: _product.imageUrl,
              isFavorite: _product.isFavorite,
            ));
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
    // updating products
    else {
      try {
        final url = Uri.https("flutter-shop-v1-default-rtdb.firebaseio.com",
            "/products/${_product.id}.json");

        await http.patch(url,
            body: json.encode({
              "title": _product.title,
              "description": _product.description,
              "price": _product.price,
              "imageUrl": _product.imageUrl,
              // "isFavorite": _product.isFavorite,
            }));

        int _idx = _items
            .indexOf(_items.firstWhere((element) => element.id == _product.id));
        _items[_idx] = _product;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Product getElementById(id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future fetchSetProducts() async {
    final url = Uri.https(
        "flutter-shop-v1-default-rtdb.firebaseio.com", "/products.json");

    // trying
    try {
      final response = await http.get(url);
      final decodedMap = json.decode(response.body) as Map<String, dynamic>;
      List<Product> _temp = [];
      // decoded
      decodedMap.forEach((productId, productData) {
        // temp prod
        var _p = Product(
            id: productId,
            title: productData["title"],
            description: productData["description"],
            imageUrl: productData["imageUrl"],
            price: productData["price"],
            isFavorite: productData["isFavorite"]);
        _temp.add(_p);
      });

      _items = _temp;
      // notify try
      notifyListeners();
    }

    // catching
    catch (e) {
      rethrow;
    }
  }

  Future<void> removeProduct(String _id) async {
    try {
      final url = Uri.https(
          "flutter-shop-v1-default-rtdb.firebaseio.com", "/products/$_id.json");
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException("Could not delete product, try again later.");
      }
      _items.removeWhere(
        (element) => element.id == _id,
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

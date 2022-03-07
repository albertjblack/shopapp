import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import './../models/http_exception.dart';

// we only want to change data from within, so notifyListeners let know all the other part that are listening
class ProductsProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;
  List _items = [];
  ProductsProvider(this.authToken, this.userId, this._items);

  // changenotifier allows us to establish behind the scenes comunications with the help of context
  // we do not want to edit _items when product change
  // we want to call a method to update the _items with listeners

  // since the _items is private we need to add a getter
  List<Product> get items {
    // we return a copy of _items
    // if we returned the _items list then it would return a pointer to _items
    // we don't want to directly edit because we would not be able to call notifyListeners
    return [..._items];
  }

  List<Product> get favs {
    return _items.where((e) => e.isFavorite == true).toList() as List<Product>;
  }

  Future addProduct(String _action, Product _product) async {
    final url = Uri.https("flutter-shop-v1-default-rtdb.firebaseio.com",
        "/products.json", {"auth": authToken});
    if (_action == "add") {
      try {
        // req
        final response = await http.post(url,
            body: json.encode({
              "title": _product.title,
              "description": _product.description,
              "price": _product.price,
              "imageUrl": _product.imageUrl,
              "creatorId": userId
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
            "/products/${_product.id}.json", {"auth": authToken});

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

  Future fetchSetProducts([bool filterByUser = false]) async {
    final url = Uri.https("flutter-shop-v1-default-rtdb.firebaseio.com",
        "/products.json", {"auth": authToken});
    final filteredUrl = Uri.https(
        "flutter-shop-v1-default-rtdb.firebaseio.com",
        "/products.json",
        {"auth": authToken, "orderBy": "creatorId", "equalTo": "$userId"});
    final favsUrl = Uri.https("flutter-shop-v1-default-rtdb.firebaseio.com",
        "/favorites/$userId.json", {"auth": authToken});

    final _url = filterByUser ? filteredUrl : url;
    // trying
    try {
      final response = await http.get(_url);
      final decodedMap = json.decode(response.body);
      if (decodedMap == null || decodedMap["error"] != null) {
        _items = [];
        return;
      }
      final favsResponse = await http.get(favsUrl);
      final favsData = json.decode(favsResponse.body);
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
            isFavorite:
                favsData == null ? false : favsData[productId] ?? false);
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
      final url = Uri.https("flutter-shop-v1-default-rtdb.firebaseio.com",
          "/products/$_id.json", {"auth": authToken});
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

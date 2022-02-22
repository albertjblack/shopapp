import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../constants/dummy_data.dart';
import './product.dart';

// we only want to change data from within, so notifyListeners let know all the other part that are listening
class ProductsProvider with ChangeNotifier {
  // changenotifier allows us to establish behind the scenes comunications with the help of context
  // we do not want to edit _items when product change
  // we want to call a method to update the _items with listeners
  final List<Product> _items = dummyProducts;

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

  Future addProduct(String _action, Product _product) {
    final url = Uri.https(
        "flutter-shop-v1-default-rtdb.firebaseio.com", "/products.json");
    if (_action == "add") {
      return http
          .post(url,
              body: json.encode({
                "title": _product.title,
                "description": _product.description,
                "price": _product.price,
                "imageUrl": _product.imageUrl,
                "isFavorite": _product.isFavorite,
              }))
          .then((value) {
        String _id = json.decode(value.body)["name"];
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
      }).catchError((e) {
        throw e;
      });
    } else {
      int _idx = _items
          .indexOf(_items.firstWhere((element) => element.id == _product.id));
      _items[_idx] = _product;
      notifyListeners();

      return Future.value();
    }
  }

  Product getElementById(id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void removeProduct(String _id) {
    _items.removeWhere((element) => element.id == _id);
    notifyListeners();
  }
}

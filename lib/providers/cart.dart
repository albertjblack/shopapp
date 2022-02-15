import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyCartItem {
  final String? id;
  final String? title;
  final String? productId;
  final int? quantity;
  final double? price;

  MyCartItem(
      {@required this.id, // diff from the product
      @required this.title,
      @required this.quantity,
      @required this.price,
      @required this.productId});
}

class Cart with ChangeNotifier {
  // map every cart item to the id of the product it belongs to

  Map<String, MyCartItem> _items = {}; // {ProductId: cartItem}
  Map<String, MyCartItem> get items {
    return {..._items};
  }

  int get itemCount {
    try {
      return _items.length;
    } catch (e) {
      return 0;
    }
  }

  double get totalSum {
    var _total = 0.0;
    _items.forEach((key, value) {
      _total += value.price! * value.quantity!;
    });
    return _total;
  }

  void addItem(String productId, double productPrice, String productTitle,
      String _productId) {
    // check if we already have the item -- if we do -- we only increase quantity
    if (_items.containsKey(productId)) {
      // chg qty
      _items.update(
          productId,
          (existing) => MyCartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity! + 1,
              price: existing.price! + productPrice,
              productId: _productId));
    } else {
      // add item
      _items.putIfAbsent(
          productId,
          () => MyCartItem(
              id: DateTime.now().toString(),
              title: productTitle,
              quantity: 1,
              price: productPrice,
              productId: _productId));
    }

    // notify listeners of changes
    notifyListeners();
  }

  void removeItem(String _productId) {
    if (_items.containsKey(_productId)) {
      _items.remove(_productId);
    }
    notifyListeners();
  }

  void removeSingleItem(String _productId) {
    if (!_items.containsKey(_productId)) {
      return;
    }
    if (_items[_productId]!.quantity! > 1) {
      _items.update(
          _productId,
          (existing) => MyCartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity! - 1,
              price: existing.price!,
              productId: _productId));
    } else {
      removeItem(_productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
  // final brace
}

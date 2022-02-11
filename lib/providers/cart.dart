import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _CartItem {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;

  _CartItem(
      {@required this.id, // diff from the product
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  // map every cart item to the id of the product it belongs to
  Map<String, _CartItem> _items = {}; // nothing initially
  Map<String, _CartItem> get items {
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
    try {
      _items.forEach((key, value) {
        _total += value.price! * value.quantity!;
      });
    } catch (e) {}
    return _total;
  }

  void addItem(String productId, double productPrice, String productTitle) {
    // check if we already have the item -- if we do -- we only increase quantity
    if (_items.containsKey(productId)) {
      // chg qty
      _items.update(
          productId,
          (existing) => _CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity! + 1,
              price: existing.price! + productPrice));
    } else {
      // add item
      _items.putIfAbsent(
          productId,
          () => _CartItem(
              id: DateTime.now().toString(),
              title: productTitle,
              quantity: 1,
              price: productPrice));
    }

    // notify listeners of changes
    notifyListeners();
  }
}

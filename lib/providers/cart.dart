import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _CartItem {
  final String? id;
  final String? title;
  final String? productId;
  final int? quantity;
  final double? price;

  _CartItem(
      {@required this.id, // diff from the product
      @required this.title,
      @required this.quantity,
      @required this.price,
      @required this.productId});
}

class Cart with ChangeNotifier {
  // map every cart item to the id of the product it belongs to

  final Map<String, _CartItem> _items = {}; // {ProductId: cartItem}
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
          (existing) => _CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity! + 1,
              price: existing.price! + productPrice,
              productId: _productId));
    } else {
      // add item
      _items.putIfAbsent(
          productId,
          () => _CartItem(
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

  void substractItem(String _productId, int quantity) async {
    // Operation was successful and item was removed from remote server
    // Dismissible is removed
    if (_items.containsKey(_productId)) {
      if (_items[_productId]!.quantity! - 1 <= 0) {
        removeItem(_productId);
      } else {
        _items.update(
            _productId,
            (existing) => _CartItem(
                id: existing.id,
                title: existing.title,
                quantity: existing.quantity! - 1,
                price: existing.price!,
                productId: _productId));
        notifyListeners();
      }

      // Operation failed and Dismissible is reset
    }
  }
}

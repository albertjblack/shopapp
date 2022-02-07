import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;

  CartItem(
      {@required this.id, // diff from the product
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  // map every cart item to the id of the product it belongs to
  Map<String, CartItem>? _items; // nothing initially
  Map<String, CartItem> get items {
    return {..._items!};
  }

  void addItem(String productId, double productPrice, String productTitle) {
    // check if we already have the item -- if we do -- we only increase quantity
    if (_items!.containsKey(productId)) {
      // chg qty
      _items!.update(
          productId,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity! + 1,
              price: existing.price! + productPrice));
    } else {
      // add item
      _items!.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: productTitle,
              quantity: 1,
              price: productPrice));
    }
  }
}

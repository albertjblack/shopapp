import 'package:flutter/material.dart';

import './cart.dart';

/* ORDER ITEM */

class MyOrderItem {
  final String? id;
  final double? amount;
  final List<MyCartItem>? items;
  final DateTime? dateTime;

  MyOrderItem(
      {@required this.id,
      @required this.amount,
      @required this.items,
      @required this.dateTime});
}

/* ORDERS */

class Orders with ChangeNotifier {
  final List<MyOrderItem> _orders = [];

  // getters
  List<MyOrderItem> get orders {
    return [..._orders];
  }

  // methods
  void addOrder(List<MyCartItem> cartItems, double total) {
    // add all the content of the cart in 1 order
    _orders.insert(
        0,
        MyOrderItem(
            id: DateTime.now().toString(),
            amount: total,
            items: cartItems,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
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
  final String? authToken;
  final String? userId;
  Orders(this.authToken, this.userId, this._orders);
  List<MyOrderItem>? _orders = [];

  // getters
  List<MyOrderItem> get orders {
    return [..._orders!];
  }

  // methods
  Future fetchSetOrders() async {
    List<MyOrderItem> _temp = [];
    final url = Uri.https("flutter-shop-v1-default-rtdb.firebaseio.com",
        "/orders/$userId.json", {"auth": authToken});
    try {
      final response = await http.get(url);
      final decodedMap = json.decode(response.body) as Map<String, dynamic>?;
      if (decodedMap == null) {
        return;
      }
      decodedMap.forEach((orderId, orderData) {
        List<MyCartItem> _orderItems = [];
        var _orderItemsItem = orderData["items"] as List;
        for (Map e in _orderItemsItem) {
          _orderItems.add(MyCartItem(
              id: e["id"],
              title: e["title"],
              quantity: e["quantity"],
              price: e["price"],
              productId: e["productId"]));
        }
        _temp.add(MyOrderItem(
            id: orderId,
            amount: orderData["amount"],
            items: _orderItems,
            dateTime: DateTime.parse(orderData["dateTime"])));
      });
      _orders = _temp.reversed.toList();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future addOrder(List<MyCartItem> cartItems, double total) async {
    final _dateTime = DateTime.now();
    final url = Uri.https("flutter-shop-v1-default-rtdb.firebaseio.com",
        "/orders/$userId.json", {"auth": authToken});

    try {
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            // will turn each CartItem in the list to a map representing itself
            "items": cartItems
                .map((e) => {
                      "id": e.id,
                      "title": e.title,
                      "quantity": e.quantity,
                      "price": double.parse(e.price!.toStringAsPrecision(2)),
                      "productId": e.productId
                    })
                .toList(),
            "dateTime": _dateTime.toIso8601String()
          }));
      debugPrint(response.body.toString());
      // add all the content of the cart in 1 order
      String _id = json.decode(response.body)["name"];

      _orders!.insert(
          0,
          MyOrderItem(
              id: _id, amount: total, items: cartItems, dateTime: _dateTime));
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }
}

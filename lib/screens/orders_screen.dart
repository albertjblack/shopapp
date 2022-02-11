import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/orders.dart';

import './../widgets/order_item.dart';
import './../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (ctx, i) => OrderItem(ordItem: orders.orders[i]),
      ),
      drawer: const AppDrawer(),
    );
  }
}

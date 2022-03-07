import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/orders.dart';

import './../widgets/order_item.dart';
import './../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: FutureBuilder(
          future: _ordersFuture!,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text(
                      "Error occurred while loading your orders, please try again."),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orders, child) => ListView.builder(
                          itemCount: orders.orders.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(ordItem: orders.orders[i]),
                        ));
              }
            }
          }),
      drawer: const AppDrawer(),
    );
  }
}

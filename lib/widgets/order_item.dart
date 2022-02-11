import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import './../providers/orders.dart';

class OrderItem extends StatelessWidget {
  final MyOrderItem? ordItem;

  const OrderItem({@required this.ordItem, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context)
        .orders
        .where((element) => element.id == ordItem!.id)
        .first;
    // this card is suppose to be expandable and show more details on tap
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${order.amount}'),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(order.dateTime!)),
          trailing: IconButton(
            icon: const Icon(Icons.expand_more),
            onPressed: () {},
          ),
        )
      ]),
    );
  }
}

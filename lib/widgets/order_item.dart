import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'dart:math';

import './../providers/orders.dart';
import './../providers/products_provider.dart';
import './../widgets/product_item.dart';

class OrderItem extends StatefulWidget {
  final MyOrderItem? ordItem;

  const OrderItem({@required this.ordItem, Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpaned = false;
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context)
        .orders
        .where((element) => element.id == widget.ordItem!.id)
        .first;
    final products = Provider.of<ProductsProvider>(context);
    // this card is suppose to be expandable and show more details on tap
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${order.amount}'),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(order.dateTime!)),
          trailing: IconButton(
            icon: Icon(isExpaned ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                isExpaned = !isExpaned;
              });
            },
          ),
        ),
        if (isExpaned)
          Container(
            height: min(widget.ordItem!.items!.length * 20.0 + 10, 180.0),
            child: ListView.builder(
                itemCount: order.items!.length,
                itemBuilder: (_, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, bottom: 3),
                        child: FittedBox(
                          child: Text(
                            "${order.items![i].title!} ",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, bottom: 3),
                        child: Text(
                          "${order.items![i].quantity}x / \$${order.items![i].price!}",
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        ),
                      )
                    ],
                  );
                }),
          )
      ]),
    );
  }
}

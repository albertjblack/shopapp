import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;

  CartItem(
      {@required this.id, // diff from the product
      @required this.title,
      @required this.quantity,
      @required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: FittedBox(
                  child: Text(
                "\$${price}",
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          title: Text(title!),
          subtitle: Text("Total: \$${price! * quantity!}"),
          trailing: Text("${quantity!}x"),
        ),
      ),
    );
  }
}

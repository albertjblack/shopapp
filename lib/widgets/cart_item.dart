import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;

  const CartItem(
      {@required this.id, // diff from the product
      @required this.title,
      @required this.quantity,
      @required this.price,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          color: Theme.of(context)
              .errorColor), // this is the cart_item id, not the productId from map
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FittedBox(
                    child: Text(
                  "\$$price",
                  style: const TextStyle(color: Colors.white),
                )),
              ),
            ),
            title: Text(title!),
            subtitle: Text("Total: \$${price! * quantity!}"),
            trailing: Text("${quantity!}x"),
          ),
        ),
      ),
    );
  }
}

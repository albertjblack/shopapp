import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/cart.dart';

class DismissCartItem extends StatelessWidget {
  final String? productId;
  final String? cartItemId;
  final Cart? cart;
  final Widget? ch;

  const DismissCartItem(
      {@required this.productId,
      @required this.cartItemId,
      @required this.cart,
      @required this.ch,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final quantity = Provider.of<Cart>(context).items[productId]!.quantity!;
    return Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            cart!.substractItem(productId!, quantity);
          } else if (direction == DismissDirection.endToStart) {
            cart!.removeItem(productId!);
          }
        },
        key: ValueKey(cartItemId!),
        background: Container(
          color: Theme.of(context).errorColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          width: double.infinity,
          child: Container(
            color: Theme.of(context).errorColor,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 25,
            ),
            padding: const EdgeInsets.only(right: 25),
            alignment: Alignment.centerRight,
          ),
        ), // this is the cart_item id, not the productId from map
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ch,
            )));
  }
}

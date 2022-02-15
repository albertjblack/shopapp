import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/cart.dart';
import './../widgets/dismiss_cart_item.dart';

class CartItem extends StatelessWidget {
  final String? id;
  final String? title;
  final String? productId;
  final int? quantity;
  final double? price;

  const CartItem(
      {@required this.id, // diff from the product
      @required this.title,
      @required this.quantity,
      @required this.price,
      @required this.productId,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    return DismissCartItem(
        productId: productId,
        cartItemId: id,
        cart: cart,
        ch: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: FittedBox(
                  child: Text(
                "\$${price!.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white),
              )),
            ),
          ),
          title: Text(title!),
          subtitle: Text("Total: \$${(price! * quantity!).toStringAsFixed(2)}"),
          trailing: Text("${quantity!}x"),
        ));
  }
}

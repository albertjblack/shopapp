import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/cart.dart';
import './../providers/orders.dart';

import './orders_screen.dart';

import './../widgets/cart_item.dart';
import './../widgets/app_drawer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    // we'd like to make a list of items where we can delete them, a part to see full price and purchase too

    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: Column(
        children: [
          Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /* Text(
                      "Total:",
                      style: TextStyle(fontSize: 20),
                    ), */
                    //Spacer(),
                    Chip(
                      label: Text(
                        "\$${(cart.totalSum).toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6!
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ), // a little bit like our badge widget
                    TextButton(
                        onPressed: () {
                          if (cart.totalSum > 0) {
                            orders.addOrder(
                                cart.items.values.toList(), cart.totalSum);
                            cart.clearCart();
                            Navigator.pushNamed(
                                context, OrdersScreen.routeName);
                          }
                        },
                        child: Text(
                          "Order now",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      price: cart.items.values.toList()[i].price,
                      quantity: cart.items.values.toList()[i].quantity,
                      title: cart.items.values.toList()[i].title,
                      productId: cart.items.keys.toList()[i],
                    )),
          )
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}

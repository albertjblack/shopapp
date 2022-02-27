import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/cart.dart';
import './../providers/orders.dart';

import './orders_screen.dart';

import './../widgets/cart_item.dart';
import './../widgets/app_drawer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = "/cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _orderProcessing = false;

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
                    ),
                    _orderProcessing
                        ? const CircularProgressIndicator()
                        : // a little bit like our badge widget
                        cart.totalSum <= 0
                            ? Text(
                                "Order now",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              )
                            : TextButton(
                                onPressed: () async {
                                  setState(() {
                                    _orderProcessing = true;
                                  });
                                  if (cart.totalSum > 0) {
                                    try {
                                      await orders.addOrder(
                                          cart.items.values.toList(),
                                          cart.totalSum);
                                      cart.clearCart();
                                      Navigator.pushNamed(
                                          context, OrdersScreen.routeName);
                                      setState(() {
                                        _orderProcessing = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        _orderProcessing = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        duration: const Duration(seconds: 2),
                                        content: const Text(
                                          "Failed to add order, please try again.",
                                          textAlign: TextAlign.center,
                                        ),
                                      ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      duration: const Duration(seconds: 2),
                                      content: const Text(
                                        "No items in cart yet, add some before ordering.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  }
                                },
                                child: Text(
                                  "Order now",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
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

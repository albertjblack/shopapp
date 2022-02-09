import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    // we'd like to make a list of items where we can delete them, a part to see full price and purchase too

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Column(
        children: [
          Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
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
                        onPressed: () {},
                        child: Text(
                          "Order now",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

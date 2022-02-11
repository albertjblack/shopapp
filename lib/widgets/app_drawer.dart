import 'package:flutter/material.dart';

import './../screens/cart_screen.dart';
import './../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: const Text("Hello friend"),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Shop'),
          onTap: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        ListTile(
          leading: const Icon(Icons.shopping_basket_sharp),
          title: const Text('Orders'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(OrdersScreen.routeName),
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: const Text('Cart'),
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(CartScreen.routeName),
        )
      ],
    ));
  }
}

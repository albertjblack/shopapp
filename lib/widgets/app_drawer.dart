import 'package:flutter/material.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:provider/provider.dart';

import './../providers/auth.dart';

import './../screens/cart_screen.dart';
import './../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: const Text("Hello lover!"),
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
        ),
        ListTile(
          leading: const Icon(Icons.person_rounded),
          title: const Text('Mine'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(UserProductsScreen.routeName),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
            Navigator.of(context).pop();
          },
        )
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import './../widgets/app_drawer.dart';
import './../widgets/user_item.dart';

import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const String routeName = "/my-products";

  @override
  Widget build(BuildContext context) {
    final userProducts = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("My products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: userProducts.length,
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    UserItem(
                      id: userProducts[i].id,
                      title: userProducts[i].title,
                      imageUrl: userProducts[i].imageUrl,
                    ),
                    const Divider()
                  ],
                );
              })),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/products_provider.dart';
import './../constants/constants.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/product-detail';
  //Product product;
  //ProductDetailScreen(@required this.product);
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context, listen: false)
        .getElementById(productId);
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(product.title!),
            Text("\$${product.price!}"),
          ],
        ),
      ),
    );
  }
}

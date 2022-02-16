import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(product.imageUrl!, fit: BoxFit.cover),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(bottom: 20, top: 0),
              child: Center(
                child: ListTile(
                  title: FittedBox(
                      child: Text(
                    "${product.title}",
                  )),
                  trailing: FittedBox(
                    child: Text(
                      "\$${product.price}",
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(80),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                "${product.description}",
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '.././providers/auth.dart';

import './../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);
  //Product? product;
  //ProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return Consumer<Product>(
      builder: (context, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.id);
              },
              child: Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
            footer: GridTileBar(
              leading: IconButton(
                icon: product.isFavorite!
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                onPressed: () async {
                  // part 1
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    duration: const Duration(seconds: 2),
                    content: !product.isFavorite!
                        ? Text(
                            "Added '${product.title!}' to favorites",
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            "Removed '${product.title!}' from favorites",
                            textAlign: TextAlign.center,
                          ),
                    action: SnackBarAction(
                      textColor: Colors.orange.shade100,
                      label: "Undo",
                      onPressed: () async {
                        try {
                          await product.toggleFavorite(
                              Provider.of<Auth>(context, listen: false).token!,
                              Provider.of<Auth>(context, listen: false)
                                  .userId!);
                        } catch (e) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor,
                              duration: const Duration(seconds: 2),
                              content: const Text(
                                "Failed to toggle favorite, please try again.",
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              )));
                        }
                      },
                    ),
                  ));
                  // part 2
                  try {
                    await product.toggleFavorite(
                        Provider.of<Auth>(context, listen: false).token!,
                        Provider.of<Auth>(context, listen: false).userId!);
                  } catch (e) {
                    debugPrint(e.toString());
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        duration: const Duration(seconds: 2),
                        content: const Text(
                            "Failed to toggle favorite, please try again.",
                            textAlign: TextAlign.center)));
                  }
                },
              ),
              backgroundColor: Colors.black54,
              title: Text(
                product.title!,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  cart.addItem(
                      product.id!, product.price!, product.title!, product.id!);
                  // establish connection to nearest scaffold (controls entire page) | products_overview
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    duration: const Duration(seconds: 2),
                    content: Text(
                      "Added item '${product.title!}' to cart",
                    ),
                    action: SnackBarAction(
                      textColor: Colors.orange.shade100,
                      label: "Undo",
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      },
                    ),
                  ));
                },
              ),
            )),
      ),
    );
  }
}

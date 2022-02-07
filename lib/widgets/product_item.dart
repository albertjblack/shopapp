import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../screens/product_detail_screen.dart';
import '../../models/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
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
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () => product.toggleFavorite(),
              ),
              backgroundColor: Colors.black54,
              title: Text(
                product.title!,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  cart.addItem(product.id!, product.price!, product.title!);
                },
              ),
            )),
      ),
    );
  }
}

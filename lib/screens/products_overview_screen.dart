import 'package:flutter/material.dart';

import './../models/product.dart';
import './../constants/dummy_data.dart';
import './../constants/constants.dart';
import './../widgets/product_item.dart';
import './../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  if (selectedValue == FilterOptions.Favorites) {
                    // do something that reduces the amount of items we show
                    setState(() {
                      _showOnlyFavs = true;
                    });
                  } else {
                    // show all items
                    setState(() {
                      _showOnlyFavs = false;
                    });
                  }
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                          child: Text('Only Favorites'),
                          value: FilterOptions.Favorites),
                      PopupMenuItem(
                          child: Text('Show All'), value: FilterOptions.All)
                    ])
          ],
        ),
        body: ProductsGrid(_showOnlyFavs));
  }
}

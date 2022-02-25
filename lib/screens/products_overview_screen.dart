import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import './../models/product.dart';
//import './../constants/dummy_data.dart';
//import './../widgets/product_item.dart';

import './../constants/constants.dart';

import './../providers/cart.dart';
import './../providers/products.dart';

import './cart_screen.dart';

import './../widgets/products_grid.dart';
import './../widgets/badge.dart';
import './../widgets/app_drawer.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

// state code

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isInit = true;
  var _showOnlyFavs = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                if (selectedValue == FilterOptions.favorites) {
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
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.favorites),
                    const PopupMenuItem(
                        child: Text('Show All'), value: FilterOptions.all)
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
                key: null,
                child: ch, // child of badge
                value: cart.itemCount.toString()),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ), // child of consumer
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(showOnlyFavs: _showOnlyFavs),
      drawer: const AppDrawer(),
    );
  }
}

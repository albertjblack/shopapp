import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/orders_screen.dart';

import './constants/colors.dart';
import './constants/constants.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders())
      ],
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(
            primarySwatch: generateMaterialColor(Color(primaryColor)),
            secondaryHeaderColor: Color(secondaryColor),
            fontFamily: 'Lato'),
        routes: {
          '/': (context) => const ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen()
        },
      ),
    );
  }
}

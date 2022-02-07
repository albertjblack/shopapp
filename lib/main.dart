import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopapp/screens/product_detail_screen.dart';

import './constants/colors.dart';
import './constants/constants.dart';
import './screens/products_overview_screen.dart';

import './providers/products_provider.dart';
import './providers/cart.dart';

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
        ChangeNotifierProvider(create: (_) => Cart())
      ],
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(
            primarySwatch: generateMaterialColor(Color(primaryColor)),
            secondaryHeaderColor: Color(secondaryColor),
            fontFamily: 'Lato'),
        routes: {
          '/': (context) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen()
        },
      ),
    );
  }
}

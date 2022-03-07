import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './screens/orders_screen.dart';

import './constants/colors.dart';
import './constants/constants.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import 'providers/products.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (_) => ProductsProvider(null, null, []),
          update: (ctx, auth, previous) => ProductsProvider(
              auth.token, auth.userId, previous == null ? [] : previous.items),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, null, []),
          update: (_, auth, prev) =>
              Orders(auth.token, auth.userId, prev == null ? [] : prev.orders),
        )
      ],
      child: Consumer<Auth>(
        // rebuild part whenever auth changes (notifyListeners)
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          theme: ThemeData(
              primarySwatch: generateMaterialColor(Color(primaryColor)),
              secondaryHeaderColor: Color(secondaryColor),
              fontFamily: 'Lato'),
          routes: {
            '/': (context) => auth.isAuth
                ? const ProductsOverviewScreen()
                : const AuthScreen(),
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen()
          },
        ),
      ),
    );
  }
}

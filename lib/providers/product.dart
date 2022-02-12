import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String? id; // final cuz we expect to get it when product gets created
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool? isFavorite; // not final because it can chang after the product creation

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void toggleFavorite() {
    isFavorite = !isFavorite!;
    notifyListeners();
  }
}

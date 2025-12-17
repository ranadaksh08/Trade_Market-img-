import 'package:agoraofolymus/models/product.dart';
import 'package:flutter/material.dart';

class Shop extends ChangeNotifier {
  //products for sale 
  final List<Product> _marketplace = [];

  List<Product> get marketplace => _marketplace;

  void addProduct(Product product){
    _marketplace.add(product);
    notifyListeners();
  }

}
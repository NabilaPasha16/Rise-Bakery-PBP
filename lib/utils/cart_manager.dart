import 'package:flutter/foundation.dart';
import '../model/cake.dart';

class CartManager extends ChangeNotifier {
  CartManager._privateConstructor();
  static final CartManager _instance = CartManager._privateConstructor();
  factory CartManager() => _instance;

  final List<Cake> _items = [];

  List<Cake> get items => List.unmodifiable(_items);

  void add(Cake cake) {
    _items.add(cake);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get total => _items.fold(0.0, (s, it) => s + it.price);
}

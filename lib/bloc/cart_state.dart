import '../model/cake.dart';

abstract class CartState {
  final List<Cake> items;
  const CartState(this.items);
}

class CartInitial extends CartState {
  const CartInitial() : super(const []);
}

class CartUpdated extends CartState {
  const CartUpdated(List<Cake> items) : super(items);
}

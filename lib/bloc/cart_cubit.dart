import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/cake.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial());

  List<Cake> get items => List.unmodifiable(state.items);

  void add(Cake cake) {
    final updated = List<Cake>.from(state.items)..add(cake);
    emit(CartUpdated(updated));
  }

  void removeAt(int index) {
    final updated = List<Cake>.from(state.items)..removeAt(index);
    emit(CartUpdated(updated));
  }

  void clear() {
    emit(const CartUpdated([]));
  }

  double get total => state.items.fold(0.0, (s, it) => s + it.price);
}

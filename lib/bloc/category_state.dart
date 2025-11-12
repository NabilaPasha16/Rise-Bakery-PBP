import '../model/cake_category.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoaded extends CategoryState {
  final List<CakeCategory> categories;
  const CategoryLoaded(this.categories);
}

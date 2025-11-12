import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_state.dart';
import '../services/api_service.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final ApiService apiService;
  CategoryCubit({required this.apiService}) : super(const CategoryInitial());

  Future<void> fetchCategories() async {
    try {
      final cats = await apiService.fetchCategories();
      emit(CategoryLoaded(cats));
    } catch (_) {
      emit(const CategoryLoaded([]));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import '../services/api_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiService apiService;
  HomeCubit({required this.apiService}) : super(const HomeInitial());

  /// Example loader: fetch some cakes as featured data
  Future<void> loadFeatured() async {
    try {
      final cakes = await apiService.fetchCakes();
      emit(HomeLoaded({'featured': cakes}));
    } catch (_) {
      emit(const HomeLoaded({'featured': []}));
    }
  }
}

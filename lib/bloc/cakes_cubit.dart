import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import 'cakes_state.dart';

class CakesCubit extends Cubit<CakesState> {
  final ApiService apiService;

  CakesCubit({required this.apiService}) : super(CakesInitial());

  Future<void> fetchCakes() async {
    emit(CakesLoading());
    try {
      final cakes = await apiService.fetchCakes();
      emit(CakesLoaded(cakes));
    } catch (e) {
      emit(CakesError(e.toString()));
    }
  }

  Future<void> search(String query) async {
    emit(CakesLoading());
    try {
      final cakes = await apiService.fetchCakes(query: query);
      emit(CakesLoaded(cakes));
    } catch (e) {
      emit(CakesError(e.toString()));
    }
  }
}

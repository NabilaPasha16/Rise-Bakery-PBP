import '../model/cake.dart';

abstract class CakesState {}

class CakesInitial extends CakesState {}

class CakesLoading extends CakesState {}

class CakesLoaded extends CakesState {
  final List<Cake> cakes;
  CakesLoaded(this.cakes);
}

class CakesError extends CakesState {
  final String message;
  CakesError(this.message);
}

part of 'fetch_meals_cubit.dart';

abstract class FetchMealsState extends Equatable {
  const FetchMealsState();

  @override
  List<Object> get props => [];
}

class FetchMealsInitial extends FetchMealsState {}

class FetchMealsLoading extends FetchMealsState {}

class FetchMealsSuccess extends FetchMealsState {
  const FetchMealsSuccess(this.data);

  final List<Meal> data;

  @override
  List<Object> get props => [data];
}

class FetchMealsFailure extends FetchMealsState {
  const FetchMealsFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

part of 'fav_meals_cubit.dart';

abstract class FavMealsState extends Equatable {
  const FavMealsState();

  @override
  List<Object> get props => [];
}

class FavMealsInitial extends FavMealsState {}

class FavMealsLoading extends FavMealsState {}

class FavMealsSuccess extends FavMealsState {
  const FavMealsSuccess(this.data);

  final List<Meal> data;

  @override
  List<Object> get props => [data];
}

class FavMealsFailure extends FavMealsState {
  const FavMealsFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

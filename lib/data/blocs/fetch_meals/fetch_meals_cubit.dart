import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fetch_meals_state.dart';

class FetchMealsCubit extends Cubit<FetchMealsState> {
  FetchMealsCubit() : super(FetchMealsInitial());
}

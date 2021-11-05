import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/db/database.dart';

part 'fav_meals_state.dart';

class FavMealsCubit extends Cubit<FavMealsState> implements Disposable {
  FavMealsCubit(this.database) : super(FavMealsInitial());

  final Database database;

  Future<void> load(Category category) async {
    emit(FavMealsLoading());
    try {
      List<Meal> res = await database.getMealsByFav();
      emit(FavMealsSuccess(res));
    } catch (error) {
      emit(FavMealsFailure(error.toString()));
    }
  }

  @override
  void dispose() {
    close();
  }
}

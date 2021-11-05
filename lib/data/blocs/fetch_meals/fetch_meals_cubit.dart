import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/repositories/meal_repository.dart';

part 'fetch_meals_state.dart';

class FetchMealsCubit extends Cubit<FetchMealsState> implements Disposable {
  FetchMealsCubit(this.mealRepository, this.database)
      : super(FetchMealsInitial());

  final MealRepository mealRepository;
  final Database database;

  Future<void> load(Category category) async {
    emit(FetchMealsLoading());
    try {
      List<Meal> res = await database.getMealsByCategory(category);
      if (res.isEmpty) {
        final response =
            await mealRepository.fetchMealsByCategory(category.name);
        await mealRepository.persistMeals(
          response.meals
              .map((e) => MealsCompanion.insert(
                    name: e.strMeal,
                    category: category.name,
                    thumb: e.strMealThumb,
                  ))
              .toList(),
        );
        res = await database.getMealsByCategory(category);
      }
      emit(FetchMealsSuccess(res));
    } catch (error) {
      emit(FetchMealsFailure(error.toString()));
    }
  }

  @override
  void dispose() {
    close();
  }
}

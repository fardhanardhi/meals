import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/repositories/meal_repository.dart';

class SetFavCubit extends Cubit<bool> implements Disposable {
  SetFavCubit(this.entry, this.mealRepository) : super(entry.favorited);

  final Meal entry;
  final MealRepository mealRepository;

  Future<void> set(bool val) async {
    await mealRepository.updateMeal(entry.copyWith(favorited: val));
    emit(val);
  }

  @override
  void dispose() {
    close();
  }
}

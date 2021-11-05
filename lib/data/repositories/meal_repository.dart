import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/models/category.dart';
import 'package:meals/data/models/meal.dart';

class MealRepository {
  MealRepository(this._client, this._database);

  final Dio _client;
  final Database _database;

  Future<MealsRes> fetchMealsByCategory(String category) async {
    try {
      final response = await _client.get('/filter.php?c=$category');
      return MealsRes.fromJson(response.toString());
    } on DioError catch (ex) {
      String errorMessage = json.decode(ex.response.toString())["errorMessage"];
      throw Exception(errorMessage);
    }
  }

  Future persistMeals(List<MealsCompanion> entries) async {
    try {
      await _database.addMeals(entries);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future updateMeal(Meal entry) async {
    try {
      await _database.updateMeal(entry);
    } catch (ex) {
      throw Exception(ex);
    }
  }
}

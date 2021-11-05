import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/models/category.dart';

class CategoryRepository {
  CategoryRepository(this._client, this._database);

  final Dio _client;
  final Database _database;

  Future<CategoriesRes> fetchCategories() async {
    try {
      final response = await _client.get('/categories.php');
      return CategoriesRes.fromJson(response.toString());
    } on DioError catch (ex) {
      String errorMessage = json.decode(ex.response.toString())["errorMessage"];
      throw Exception(errorMessage);
    }
  }

  Future persistCategories(List<CategoriesCompanion> entries) async {
    try {
      await _database.addCategories(entries);
    } catch (ex) {
      throw Exception(ex);
    }
  }
}

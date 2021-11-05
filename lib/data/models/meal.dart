import 'dart:convert';

import 'package:equatable/equatable.dart';

class MealsRes extends Equatable {
  final List<MealRes> meals;
  const MealsRes({
    required this.meals,
  });

  MealsRes copyWith({
    List<MealRes>? meals,
  }) {
    return MealsRes(
      meals: meals ?? this.meals,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'meals': meals.map((x) => x.toMap()).toList(),
    };
  }

  factory MealsRes.fromMap(Map<String, dynamic> map) {
    return MealsRes(
      meals: List<MealRes>.from(map['meals']?.map((x) => MealRes.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MealsRes.fromJson(String source) =>
      MealsRes.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [meals];
}

class MealRes extends Equatable {
  final String strMeal;
  final String strMealThumb;
  final String idMeal;
  const MealRes({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
  });

  MealRes copyWith({
    String? strMeal,
    String? strMealThumb,
    String? idMeal,
  }) {
    return MealRes(
      strMeal: strMeal ?? this.strMeal,
      strMealThumb: strMealThumb ?? this.strMealThumb,
      idMeal: idMeal ?? this.idMeal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'strMeal': strMeal,
      'strMealThumb': strMealThumb,
      'idMeal': idMeal,
    };
  }

  factory MealRes.fromMap(Map<String, dynamic> map) {
    return MealRes(
      strMeal: map['strMeal'],
      strMealThumb: map['strMealThumb'],
      idMeal: map['idMeal'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MealRes.fromJson(String source) =>
      MealRes.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [strMeal, strMealThumb, idMeal];
}

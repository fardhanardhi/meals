import 'dart:convert';

import 'package:equatable/equatable.dart';

class CategoriesRes extends Equatable {
  final List<CategoryRes> categories;
  const CategoriesRes({
    required this.categories,
  });

  CategoriesRes copyWith({
    List<CategoryRes>? categories,
  }) {
    return CategoriesRes(
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categories': categories.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoriesRes.fromMap(Map<String, dynamic> map) {
    return CategoriesRes(
      categories: List<CategoryRes>.from(
          map['categories']?.map((x) => CategoryRes.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriesRes.fromJson(String source) =>
      CategoriesRes.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [categories];
}

class CategoryRes extends Equatable {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;
  const CategoryRes({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  CategoryRes copyWith({
    String? idCategory,
    String? strCategory,
    String? strCategoryThumb,
    String? strCategoryDescription,
  }) {
    return CategoryRes(
      idCategory: idCategory ?? this.idCategory,
      strCategory: strCategory ?? this.strCategory,
      strCategoryThumb: strCategoryThumb ?? this.strCategoryThumb,
      strCategoryDescription:
          strCategoryDescription ?? this.strCategoryDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCategory': idCategory,
      'strCategory': strCategory,
      'strCategoryThumb': strCategoryThumb,
      'strCategoryDescription': strCategoryDescription,
    };
  }

  factory CategoryRes.fromMap(Map<String, dynamic> map) {
    return CategoryRes(
      idCategory: map['idCategory'],
      strCategory: map['strCategory'],
      strCategoryThumb: map['strCategoryThumb'],
      strCategoryDescription: map['strCategoryDescription'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryRes.fromJson(String source) =>
      CategoryRes.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [idCategory, strCategory, strCategoryThumb, strCategoryDescription];
}

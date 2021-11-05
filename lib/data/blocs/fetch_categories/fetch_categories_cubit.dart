import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meals/data/db/database.dart';
import 'package:meals/data/models/category.dart';
import 'package:meals/data/repositories/category_repository.dart';

part 'fetch_categories_state.dart';

class FetchCategoriesCubit extends Cubit<FetchCategoriesState>
    implements Disposable {
  FetchCategoriesCubit(this.categoryRepository, this.database)
      : super(FetchCategoriesInitial());

  final CategoryRepository categoryRepository;
  final Database database;

  Future<void> load() async {
    emit(FetchCategoriesLoading());
    try {
      List<Category> res = await database.getAllCategoryEntries();
      if (res.isEmpty) {
        final response = await categoryRepository.fetchCategories();
        await categoryRepository.persistCategories(
          response.categories
              .map((e) => CategoriesCompanion.insert(
                    id: Value(int.parse(e.idCategory)),
                    name: e.strCategory,
                    thumb: e.strCategoryThumb,
                    description: e.strCategoryDescription,
                  ))
              .toList(),
        );
        res = await database.getAllCategoryEntries();
      }
      emit(FetchCategoriesSuccess(res));
    } catch (error) {
      emit(FetchCategoriesFailure(error.toString()));
    }
  }

  @override
  void dispose() {
    close();
  }
}

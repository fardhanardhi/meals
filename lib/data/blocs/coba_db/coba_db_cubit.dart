import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:meals/data/db/database.dart';

part 'coba_db_state.dart';

class CobaDbCubit extends Cubit<CobaDbState> {
  CobaDbCubit(this.database) : super(CobaDbInitial());

  final Database database;

  Future<void> load() async {
    emit(CobaDbLoading());
    try {
      final res = await database.getAllCategoryEntries();

      // emit(CobaDbSuccess(res));
    } catch (error) {
      emit(CobaDbFailure(error.toString()));
    }
  }

  // Future<void> add(String title, String content) async {
  //   emit(CobaDbLoading());
  //   try {
  //     await database.addTodo(
  //       TodosCompanion(
  //         title: Value(title),
  //         content: Value(content),
  //       ),
  //     );
  //     load();
  //   } catch (error) {
  //     emit(CobaDbFailure(error.toString()));
  //   }
  // }
}

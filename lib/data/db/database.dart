import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Meals extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get area => text().nullable()();
  TextColumn get thumb => text()();
  TextColumn get tags => text().nullable()();
  BoolColumn get favorited => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get thumb => text()();
  TextColumn get description => text()();

  @override
  Set<Column> get primaryKey => {id};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Meals, Categories])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (openingDetails) async {
          if (true) {
            final m = Migrator(this);
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
              await m.createTable(table);
            }
          }
        },
      );

  Future<List<Meal>> getAllMealEntries() => select(meals).get();
  Future<List<Category>> getAllCategoryEntries() => select(categories).get();

  Future<List<Meal>> getMealsByCategory(Category c) {
    return (select(meals)..where((t) => t.category.equals(c.name))).get();
  }

  Future<Meal> getMealById(int id) {
    return (select(meals)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Meal>> getMealsByFav() {
    return (select(meals)..where((t) => t.favorited.equals(true))).get();
  }

  Future<Category> getCategoryById(int id) {
    return (select(categories)..where((t) => t.id.equals(id))).getSingle();
  }

  Future updateMeal(Meal entry) {
    return update(meals).replace(entry);
  }

  Future<int> addMeal(MealsCompanion entry) {
    return into(meals).insert(entry);
  }

  Future<int> addCategory(CategoriesCompanion entry) {
    return into(categories).insert(entry);
  }

  Future<void> addMeals(List<MealsCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(meals, entries, mode: InsertMode.replace);
    });
  }

  Future<void> addCategories(List<CategoriesCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(categories, entries, mode: InsertMode.replace);
    });
  }
}

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for drift to know about the generated code
part 'coba.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  IntColumn get category => integer().nullable()();
}

// This will make drift generate a class called "Category" to represent a row in this table.
// By default, "Categorie" would have been used because it only strips away the trailing "s"
// in the table name.
@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
}

class Users extends Table {
  TextColumn get email => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {email};
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [Todos, Categories, Users])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // onCreate: (Migrator m) {
        //   return m.createAll();
        // },
        // onUpgrade: (Migrator m, int from, int to) async {
        //   if (from == 1) {
        //     // we added the dueDate property in the change from version 1
        //     await m.addColumn(todos, todos.dueDate);
        //   }
        // },
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

  // loads all todo entries
  Future<List<Todo>> get allTodoEntries => select(todos).get();

  // watches all todo entries in a given category. The stream will automatically
  // emit new items whenever the underlying data changes.
  Stream<List<Todo>> watchEntriesInCategory(Category c) {
    return (select(todos)..where((t) => t.category.equals(c.id))).watch();
  }

  Future<List<Todo>> sortEntriesAlphabetically() {
    return (select(todos)..orderBy([(t) => OrderingTerm(expression: t.title)]))
        .get();
  }

  Stream<Todo> entryById(int id) {
    return (select(todos)..where((t) => t.id.equals(id))).watchSingle();
  }

  Future moveImportantTasksIntoCategory(Category target) {
    // for updates, we use the "companion" version of a generated class. This wraps the
    // fields in a "Value" type which can be set to be absent using "Value.absent()". This
    // allows us to separate between "SET category = NULL" (`category: Value(null)`) and not
    // updating the category at all: `category: Value.absent()`.
    return (update(todos)..where((t) => t.title.like('%Important%'))).write(
      TodosCompanion(
        category: Value(target.id),
      ),
    );
  }

  Future updateTodo(Todo entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As its where clause is set automatically, it
    // cannot be used together with where.
    return update(todos).replace(entry);
  }

  Future feelingLazy() {
    // delete the oldest nine tasks
    return (delete(todos)..where((t) => t.id.isSmallerThanValue(10))).go();
  }

  // returns the generated id
  Future<int> addTodo(TodosCompanion entry) {
    return into(todos).insert(entry);
  }

  Future addTodoWithDummy() {
    return addTodo(
      const TodosCompanion(
        title: Value('Important task'),
        content: Value('Refactor persistence code'),
      ),
    );
  }

  Future<void> insertMultipleEntries() async {
    await batch((batch) {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      batch.insertAll(todos, [
        TodosCompanion.insert(
          title: 'First entry',
          content: 'My content',
        ),
        TodosCompanion.insert(
          title: 'Another entry',
          content: 'More content',
          // columns that aren't required for inserts are still wrapped in a Value:
          category: const Value(3),
        ),
        // ...
      ]);
    });
  }

  Future<void> createOrUpdateUser(User user) {
    return into(users).insertOnConflictUpdate(user);
  }
}

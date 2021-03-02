import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../models/todo.dart';

class TodoDb {
  // this needs to be a singleton
  static final TodoDb _singleton = TodoDb._internal();

  // private internal constructor
  TodoDb._internal();

  /*
     factory constructor to return the _singleton object
     A normal constructor returns a new instance of the current class. A factory constructor
     can only return a single instance of the current class. That's why factory constructors
     are often used when you need to implement the singleton pattern.
   */
  factory TodoDb() => _singleton;

  // 1 A database factory allows us to open a sembast database. Each database is a file
  DatabaseFactory dbFactory = databaseFactoryIo;

  /*
      2 After opening the database, you need to specify the location in which you want to save
      files. Stores could be considered 'folders' inside the database, they are persistent maps,
      and their values are the Todo objects.
   */
  final store = intMapStoreFactory.store('todos');

  // 3 Open the database itself
  Database _database;

  /*
      4 Checks whether the database has already been set, if it has, the getter will return
      an existing database. If it hasn't, it will call _openDb async method
   */
  Future<Database> get database async {
    if (_database == null) await _openDb().then((db) => _database = db);
    return _database;
  }

  // Opens the sembast database
  Future _openDb() async {
    // retrieve the document directory of your system
    final docsPath = await getApplicationDocumentsDirectory();
    // join the docsPath and the name of the database into a single path
    // using the current platform's separator
    final dbPath = join(docsPath.path, 'todos.db');
    // open the sembast database and return it
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future<List<Todo>> getTodos() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('priority'),
      SortOrder('id'),
    ]);

    // retrieve data from a sembast store (returns Future<List<RecordSnapshot>>)
    final todosSnapshot = await store.find(_database, finder: finder);
    // convert snapshot and transform into a list
    return todosSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      // the id is automatically generated
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }

  Future insertTodo(Todo todo) async =>
      await store.add(_database, todo.toMap());

  Future updateTodo(Todo todo) async {
    // Finder is a helper for searching a given store
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database, todo.toMap(), finder: finder);
  }

  Future deleteTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database, finder: finder);
  }

  Future deleteAll() async => await store.delete(_database);
}

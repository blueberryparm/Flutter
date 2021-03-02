import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/shopping_list.dart';
import '../models/list_items.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper.internal();
  final int version = 1;
  Database db;

  // private constructor
  DbHelper.internal();

  /*
      Factory constructor are used for implementing the singleton pattern
      which restricts the instantiation of a class to one single instance.
      The first time the factory constructor gets called, it will return a
      new instance of DbHelper. After DbHelper has already been instantiated,
      the constructor will not build another instance, but just return the
      existing one.
   */
  factory DbHelper() => _dbHelper;

  Future<Database> openDb2() async {
    if (db == null) {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'shopping.db');

      // open the database
      db = await openDatabase(
        path,
        version: version,
        onCreate: (Database database, int version) async {
          // When creating the db, create the table
          await database.execute(
              'CREATE TABLE lists (id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
          await database.execute(
              'CREATE TABLE items (id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, quantity TEXT, note TEXT, ' +
                  'FOREIGN KEY(idList)REFERENCES lists(id))');
        },
      );
    }
    return db;
  }

  // Open db if it exists or create it if it does not
  // If a database named shopping.db exists and has a version number of 1,
  // the database gets opened, otherwise it gets created
  Future<Database> openDb() async {
    if (db == null) {
      // the path of the database to be opened
      db = await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
          // will only be called if the database at the path specified is not found
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
        database.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, quantity TEXT, note TEXT, ' +
                'FOREIGN KEY(idList)REFERENCES lists(id))');
      }, version: version);
    }
    return db;
  }

  // Return a list of ShoppingList objects
  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db.query('lists');
    return List.generate(
      maps.length,
      (index) => ShoppingList(
        maps[index]['id'],
        maps[index]['name'],
        maps[index]['priority'],
      ),
    );
  }

  /*
      Insert a new record into the lists table. Returns the ID of the record
      that was inserted.
   */
  Future<int> insertList(ShoppingList list) async {
    int id = await db.insert(
      // the name of the table
      'lists',
      // a Map of the data that we want to insert
      list.toMap(),
      // if the same list is inserted multiple times, it will replace the
      // previous data with the new list that was passed to the function
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deleteList(ShoppingList list) async {
    int result = await db.delete(
      'items',
      where: 'idList = ?',
      whereArgs: [list.id],
    );

    result = await db.delete(
      'lists',
      where: 'id = ?',
      whereArgs: [list.id],
    );

    return result;
  }

  // Return a list of ListItem objects
  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'idList = ?',
      whereArgs: [idList],
    );

    return List.generate(
      maps.length,
      (index) => ListItem(
        maps[index]['id'],
        maps[index]['idList'],
        maps[index]['name'],
        maps[index]['quantity'],
        maps[index]['note'],
      ),
    );
  }

  /*
      Insert a new record into the item table. Returns the ID of the record
      that was inserted.
   */
  Future<int> insertItem(ListItem item) async {
    int id = await db.insert(
      // the name of the table
      'items',
      // a Map of the data that we want to insert
      item.toMap(),
      // if the same list is inserted multiple times, it will replace the
      // previous data with the new list that was passed to the function
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deleteItem(ListItem item) async {
    int result = await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [item.id],
    );

    return result;
  }

  // Insert some mock data into our db, and then retrieve data
  // and print it into the debug console
  Future testDb() async {
    db = await openDb();
    await db.execute('INSERT INTO lists VALUES (0, "Fruit", 2)');
    await db.execute(
        'INSERT INTO items VALUES (0, 0, "Apples", "2 Kg", "Better if they are green")');
    List lists = await db.rawQuery('select * from lists');
    List items = await db.rawQuery('select * from items');
    print(lists[0].toString());
    print(items[0].toString());
  }
}

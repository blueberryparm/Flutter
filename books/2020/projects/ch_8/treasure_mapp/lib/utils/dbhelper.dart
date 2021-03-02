import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/place.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  final int version = 1;
  Database db;
  List<Place> places = [];

  factory DbHelper() => _dbHelper;

  // This will open the database if it exists, or create it if it doesn't
  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), 'mapp.db'),
        onCreate: (database, version) {
          database.execute(
              'CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, lat DOUBLE, lon DOUBLE, image TEXT)');
        },
        version: version,
      );
    }
    return db;
  }

  // Retrieve all records from the places table
  Future<List<Place>> getPlaces() async {
    final List<Map<String, dynamic>> maps = await db.query('places');
    places = List.generate(
      maps.length,
      (index) => Place(
        maps[index]['id'],
        maps[index]['name'],
        maps[index]['lat'],
        maps[index]['lon'],
        maps[index]['image'],
      ),
    );
    return places;
  }

  Future<int> insertPlace(Place place) async => await db.insert(
        'places',
        place.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  // Delete a record from the places table
  Future<int> deletePlace(Place place) async =>
      await db.delete('places', where: 'id = ?', whereArgs: [place.id]);

  Future insertMockData() async {
    db = await openDb();

    await db.execute(
        'INSERT INTO places VALUES (1, "Beautiful park", 41.9294115, 12.5380785, "")');
    await db.execute(
        'INSERT INTO places VALUES (2, "Best Pizza in the world", 41.9294115, 12.5268947, "")');
    await db.execute(
        'INSERT INTO places VALUES (3, "The best ice cream on earth", 41.9349061, 12.5339831, "")');
    List places = await db.rawQuery('select * from places');
    print(places[0].toString());
  }
}

import 'dart:io'; // Used by File
import 'dart:convert'; // Used by JSON

import 'package:path_provider/path_provider.dart'; // Filesystem locations
import '../models/journal.dart';

/*
    Handles getting the path to the device's local documents directory and
    saving and reading the database file by using the File class
 */
class DatabaseFileRoutines {
  // Returns a Future<String> which is the documents directory path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Returns a Future<File> with the reference to the local_persistence.json
  // file which is the path combined with the file name
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/local_persistence.json');
  }

  // Check whether the file exists, if not, you create it by passing an empty
  // journals object. Load the contents of the file.
  Future<String> readJournals() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print('File does not Exist: ${file.absolute}');
        await writeJournals('{"journals": []}');
      }

      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('error readJournals: $e');
      return '';
    }
  }

  // Return a Future<File> to save the JSON objects to file
  Future<File> writeJournals(String json) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$json');
  }
}

/*
    Handles decoding and encoding the JSON objects and converting them to a List
    of journal entries. Returns the journal variable consisting of a List of Journal
    classes, List<Journal>.
 */
class Database {
  List<Journal> journal;

  Database({this.journal});

  // To retrieve and map the JSON objects to a List<Journal>
  factory Database.fromJson(Map<String, dynamic> json) => Database(
        journal: List<Journal>.from(
          json['journals'].map(
            (x) => Journal.fromJson(x),
          ),
        ),
      );

  // To convert the List<Journal> to JSON objects
  Map<String, dynamic> toJson() => {
        'journals': List<dynamic>.from(
          journal.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

// To read and parse from JSON data, returns a JSON object
Database databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return Database.fromJson(dataFromJson);
}

// To save and parse to JSON data, returns a String
String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'LayoutDrawer.dart';
//import 'utilities.dart';

class JsonReadingAndWriting extends StatefulWidget {
  @override
  _JsonReadingAndWritingState createState() => _JsonReadingAndWritingState();
}

class _JsonReadingAndWritingState extends State<JsonReadingAndWriting> {
  final String _assetFilename = 'database.json';
  String _filename = 'database.json';
  String _message = '';
  EditingStatus _editingStatus = EditingStatus.none;
  Person _person = Person();
  bool _errorStatus = false;
  TextEditingController _controller;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // To keep this demo more understandable, we made this a Map
  // but in practice, it would have been a Person class/object.
  List<Person> _people = <Person>[];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _filename);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding $_person');

    return Scaffold(
      appBar: LayoutAppBar().toPreferredSizeWidget(context),
      drawer: LayoutDrawer(),
      body: _body,
    );
  }

  Widget get _body {
    final TextStyle _messageStyle = _errorStatus
        ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyText2;
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          Text('Reading and writing JSON from $_filename'),
          RaisedButton(
            child: const Text('Refresh the database file'),
            onPressed: _refreshAssetsFile,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Filename'),
            controller: _controller,
            onChanged: (String value) => setState(() => _filename = value),
          ),
          RaisedButton(
            child: const Text('Load the database file'),
            onPressed: _loadDatabaseFile,
          ),
          DropdownButton<Person>(
            items: _people.map((Person person) {
              return DropdownMenuItem<Person>(
                value: person,
                child: Text('${person.firstName} ${person.lastName}'),
              );
            }).toList(),
            onChanged: _selectCurrentPerson,
          ),
          if (_editingStatus == EditingStatus.none)
            RaisedButton(
              child: const Text('Add New Person'),
              onPressed: _prepareAddPerson,
            ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First name'),
                  onSaved: (String value) =>
                      setState(() => _person.firstName = value),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last name'),
                  onSaved: (String value) =>
                      setState(() => _person.lastName = value),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Occupation'),
                  onSaved: (String value) =>
                      setState(() => _person.occupation = value),
                ),
              ],
            ),
          ),
          if (_editingStatus == EditingStatus.adding)
            Row(
              children: <Widget>[
                RaisedButton(
                  child: const Text('Save'),
                  onPressed: _savePerson,
                ),
                RaisedButton(
                  child: const Text('Cancel'),
                  onPressed: _cancel,
                ),
              ],
            )
          else if (_editingStatus == EditingStatus.modifying)
            Row(
              children: <Widget>[
                RaisedButton(
                  child: const Text('Save'),
                  onPressed: _savePerson,
                ),
                RaisedButton(
                  child: const Text('Cancel'),
                  onPressed: _cancel,
                ),
                RaisedButton(
                  child: const Text('Delete'),
                  onPressed: _deletePerson,
                ),
              ],
            ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Text(
              _message,
              style: _messageStyle,
            ),
          ),
        ],
      ),
    );
  }

  // Clears out the text boxes so a brand new person can be added to the list
  void _prepareAddPerson() {
    setState(() {
      _editingStatus = EditingStatus.adding;
      _person = Person();
    });
  }

  void _cancel() {
    _formKey.currentState.reset();
    setState(() {
      _editingStatus = EditingStatus.none;
      _person = Person();
    });
  }

  void _selectCurrentPerson(Person person) {
    setState(() {
      _editingStatus = EditingStatus.modifying;
      _person = person;
      print('Selected $_person');
    });
  }

  // Upserts the current person to the list of people. ie. If the person doesn't exist
  // already, add them. If they do exist, update them.
  void _savePerson() {
    setState(() {
      _formKey.currentState.save();
      if (_editingStatus == EditingStatus.adding) {
        _person.id = Uuid().v1();
        _people.add(_person);
      }
      // Not sure we have to do anything; we're already putting the names and stuff into _person which is a reference to the person in memory.
      //else
      //Person thePerson = _people.firstWhere((Person p) => p.id == _person.id);

      _editingStatus = EditingStatus.none;
      _formKey.currentState.reset();
      _saveDatabaseFile();
    });
  }

  // Delete a person from the list of people.
  void _deletePerson() {
    //_saveDatabaseFile();
  }

  // Read from the assets file and load it into the local 'database' file.
  Future<void> _refreshAssetsFile() async {
    final String _stringData =
        await rootBundle.loadString('assets/$_assetFilename');
    final Directory documents = await getApplicationDocumentsDirectory();
    _errorStatus = false;
    final File file = File('${documents.path}/$_filename');
    try {
      await file.writeAsString(_stringData);
      setState(() {
        _message = '$_filename now has this text inside it: "$_stringData"';
      });
    } catch (ex) {
      setState(() {
        _errorStatus = true;
        _message = 'Error: $ex';
      });
    }
  }

  // Reads from a flat 'database' file in JSON format and saves to state (_person)
  Future<void> _loadDatabaseFile() async {
    final Directory documents = await getApplicationDocumentsDirectory();
    _errorStatus = false;
    final File file = File('${documents.path}/$_filename');
    file.readAsString().then((String text) {
      setState(() {
        _message = '$_filename has this text inside it: "$text"';
        final Map<String, dynamic> db = json.decode(text);
        final List<dynamic> ppl = db['people'];
        _people = ppl
            .map((dynamic p) => Person(
                id: p['id'],
                firstName: p['firstName'],
                lastName: p['lastName'],
                occupation: p['occupation']))
            .toList();
      });
    }).catchError((Object e) {
      setState(() {
        _errorStatus = true;
        _message = 'Error: $e';
      });
    });
  }

  Future<void> _saveDatabaseFile() async {
    final Directory documents = await getApplicationDocumentsDirectory();
    setState(() {
      _errorStatus = false;
    });
    final File file = File('${documents.path}/$_filename');
    final Map<String, dynamic> jsonObject = <String, dynamic>{
      'people': _people
    };

    try {
      await file.writeAsString(json.encode(jsonObject));
    } catch (e) {
      print('Problem serializing: $e');
      setState(() {
        _errorStatus = true;
        _message = 'Error: $e';
      });
    }
  }
}

class Person {
  Person({this.id, this.firstName, this.lastName, this.occupation});

  String id;
  String firstName;
  String lastName;
  String occupation;

  @override
  String toString() => json.encode(this);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'occupation': occupation
      };
}

enum EditingStatus { none, adding, modifying }

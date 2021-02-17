import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LayoutDrawer.dart';

class ChangeUserPreferences extends StatefulWidget {
  @override
  _ChangeUserPreferencesState createState() => _ChangeUserPreferencesState();
}

class _ChangeUserPreferencesState extends State<ChangeUserPreferences> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  Future<void> _loading;
  String _message = '';

  @override
  void initState() {
    super.initState();
    // Load shared preferences on init.
    _loading = readFromSharedPrefs();
  }

  Future<void> readFromSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('userName');
    _colorController.text = prefs.getString('favoriteColor');
  }

  /// Writes parts of the state to SharedPrefs/NSUserDefaults
  Future<void> writeToSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs
      ..setString('userName', _nameController.text)
      ..setString('favoriteColor', _colorController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LayoutAppBar().toPreferredSizeWidget(context),
      drawer: LayoutDrawer(),
      body: FutureBuilder<dynamic>(
        future: _loading,
        // ignore: always_specify_types
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _body;
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget get _body {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          const Text(
            'Enter your preferences below and they\'ll be there next time you open the app.',
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Your name'),
            controller: _nameController,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Favorite color'),
            controller: _colorController,
          ),
          RaisedButton(
            child: const Icon(Icons.open_in_browser),
            onPressed: () async {
              try {
                await writeToSharedPrefs();
                setState(() {
                  _message = 'Preferences were saved';
                });
              } catch (e) {
                setState(() {
                  _message = 'Error: $e';
                });
              }
            },
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
            ),
          ),
        ],
      ),
    );
  }
}

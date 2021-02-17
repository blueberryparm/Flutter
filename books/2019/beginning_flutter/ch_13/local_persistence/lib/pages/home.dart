import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_persistence/pages/edit_entry.dart';
import '../models/journal.dart';
import '../models/journal_edit.dart';
import '../utils/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Database _database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Persistence'),
      ),
      body: FutureBuilder(
        // Initial data to show before the snapshot is retrieved
        initialData: [],
        // Calls a Future asynchronous method to retrieve data
        future: _loadJournals(),
        /*
            The AsyncSnapshot returns a snapshot of the data, and you can also check for
            the ConnectionState to get a status on the data retrieval process.

            AsyncSnapshot: Provides the most recent data and connection status. Note that
            the data represented is immutable and read‐only. To check whether data is
            returned, you use the snapshot.hasData.

            To check the connection state, you use the snapshot.connectionState to see whether
            the state is active, waiting, done, or none. You can also check for errors by
            using the snapshot.hasError property.

         */
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildListViewSeparated(snapshot);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(24),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Journal Entry',
        child: Icon(Icons.add),
        onPressed: () =>
            _addOrEditJournal(add: true, index: -1, journal: Journal()),
      ),
    );
  }

  // A List of Journal class entries
  Future<List<Journal>> _loadJournals() async {
    // Once the readJournals() completes and returns the value, then()
    // executes the code inside
    await DatabaseFileRoutines().readJournals().then((journalsJson) {
      // journalsJson parameter receives the value from the JSON objects read
      // from the saved local_persistence.json file located in the device
      // local documents folder

      // returns the JSON objects as a Dart list
      _database = databaseFromJson(journalsJson);
      // sort journal entries by DESC date with newer entries first and older last
      _database.journal.sort(
        (comp1, comp2) => comp2.date.compareTo(comp1.date),
      );
    });
    return _database.journal;
  }

  /*
      Handles presenting the edit entry page to either add or modify a journal entry.
      You use Navigator.push() to present the entry page and wait for the result of
      the user's actions. If the user pressed the Cancel button nothing happens but if
      they pressed the Save button, then you either add the new journal entry or save
      the changes to the current edited entry.
   */
  void _addOrEditJournal({bool add, int index, Journal journal}) async {
    JournalEdit _journalEdit = JournalEdit(action: '', journal: journal);

    _journalEdit = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntry(
          add: add,
          index: index,
          journalEdit: _journalEdit,
        ),
        fullscreenDialog: true,
      ),
    );

    switch (_journalEdit.action) {
      case 'Save':
        // adding a new entry
        if (add)
          setState(() => _database.journal.add(_journalEdit.journal));
        // saving an existing entry
        else
          setState(() => _database.journal[index] = _journalEdit.journal);
        // Save journal entry to the device local storage documents directory
        DatabaseFileRoutines().writeJournals(databaseToJson(_database));
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _titleDate = DateFormat.yMMMEd()
            .format(DateTime.parse(snapshot.data[index].date));
        String _subTitle =
            snapshot.data[index].mood + '\n' + snapshot.data[index].note;

        return Dismissible(
          key: Key(snapshot.data[index].id),
          background: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            leading: Column(
              children: [
                Text(
                  DateFormat.d().format(
                    DateTime.parse(snapshot.data[index].date),
                  ),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  DateFormat.E().format(
                    DateTime.parse(snapshot.data[index].date),
                  ),
                ),
              ],
            ),
            title: Text(
              _titleDate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(_subTitle),
            onTap: () => _addOrEditJournal(
              add: false,
              index: index,
              journal: snapshot.data[index],
            ),
          ),
          onDismissed: (direction) {
            setState(() => _database.journal.removeAt(index));
            DatabaseFileRoutines().writeJournals(
              databaseToJson(_database),
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.grey,
      ),
    );
  }
}

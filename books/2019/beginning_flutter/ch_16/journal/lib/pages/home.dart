/*
    Handles showing a list of journal entries with the ability to
    add, modify, and delete individual records.
 */

import 'package:flutter/material.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/authentication_bloc_provider.dart';
import '../blocs/home_bloc.dart';
import '../blocs/home_bloc_provider.dart';
import '../blocs/journal_edit_bloc.dart';
import '../blocs/journal_edit_bloc_provider.dart';
import '../classes/format_dates.dart';
import '../classes/mood_icons.dart';
import '../models/journal.dart';
import '../pages/edit_entry.dart';
import '../services/db_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AutheticationBloc _authenticationBloc;
  HomeBloc _homeBloc;
  String _uid;
  MoodIcons _moodIcons = MoodIcons();
  FormatDates _formatDates = FormatDates();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).autheticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Journal',
          style: TextStyle(
            color: Colors.lightGreen[800],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.lightGreen.shade800,
            ),
            onPressed: () => _authenticationBloc.logoutUser.add(true),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(32),
          child: Container(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _homeBloc.listJournal,
        // rebuilds every time a journal entry changes
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (snapshot.hasData)
            return _buildListViewSeparated(snapshot);
          else
            return Center(
              child: Container(
                child: Text('Add Journals.'),
              ),
            );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen.shade50, Colors.lightGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Journal Entry',
        backgroundColor: Colors.lightGreen[300],
        child: Icon(Icons.add),
        onPressed: () async => _addOrEditJournal(
          add: true,
          journal: Journal(uid: _uid),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      // journal's item count
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _titleDate =
            _formatDates.dateFormatShortMonthDayYear(snapshot.data[index].date);
        String _subtitle =
            snapshot.data[index].mood + '\n' + snapshot.data[index].note;
        return Dismissible(
          key: Key(snapshot.data[index].documentID),
          background: Container(
            padding: EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            padding: EdgeInsets.only(right: 16),
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
                  _formatDates.dateFormatDayNumber(
                    snapshot.data[index].date,
                  ),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                  ),
                ),
                Text(
                  _formatDates.dateFormatShortDayName(
                    snapshot.data[index].date,
                  ),
                ),
              ],
            ),
            trailing: Transform(
              transform: Matrix4.identity()
                ..rotateZ(
                  _moodIcons.getMoodRotation(snapshot.data[index].mood),
                ),
              alignment: Alignment.center,
              child: Icon(
                _moodIcons.getMoodIcon(snapshot.data[index].mood),
                color: _moodIcons.getMoodColor(snapshot.data[index].mood),
                size: 42,
              ),
            ),
            title: Text(
              _titleDate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(_subtitle),
            onTap: () => _addOrEditJournal(
              add: false,
              journal: snapshot.data[index],
            ),
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteJournal();
            if (confirmDelete) {
              _homeBloc.deleteJournal.add(snapshot.data[index]);
            }
            return true;
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.grey,
      ),
    );
  }

  // Add or Edit Journal and call the Show Entry Dialog
  void _addOrEditJournal({bool add, Journal journal}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => JournalEditBlocProvider(
          journalEditBloc: JournalEditBloc(add, journal, DbFirestoreService()),
          child: EditEntry(),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  // Confirm Deleting a Journal Entry
  Future<bool> _confirmDeleteJournal() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Journal'),
          content: Text('Are you sure you would like to Delete?'),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }
}

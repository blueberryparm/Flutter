/*
    Responsible for monitoring the journal edit page to either add a
    new or save an existing entry. Handles the journal entry page date, mood,
    note and save button. Is also responsible for calling the Cloud Firestore
    database service to save the entry.
 */

import 'dart:async';

import '../models/journal.dart';
import '../services/db_firestore_api.dart';

class JournalEditBloc {
  final DbApi dbApi;
  final bool add;
  Journal selectedJournal;

  final StreamController<String> _dateController =
      StreamController<String>.broadcast();
  Sink<String> get dateEditChanged => _dateController.sink;
  Stream<String> get dateEdit => _dateController.stream;

  final StreamController<String> _moodController =
      StreamController<String>.broadcast();
  Sink<String> get moodEditChanged => _moodController.sink;
  Stream<String> get moodEdit => _moodController.stream;

  final StreamController<String> _noteController =
      StreamController<String>.broadcast();
  Sink<String> get noteEditChanged => _noteController.sink;
  Stream<String> get noteEdit => _noteController.stream;

  final StreamController<String> _saveJournalController =
      StreamController<String>.broadcast();
  Sink<String> get saveJournalChanged => _saveJournalController.sink;
  Stream<String> get saveJournal => _saveJournalController.stream;

  JournalEditBloc(this.add, this.selectedJournal, this.dbApi) {
    _startEditListeners().then((finished) => _getJournal(add, selectedJournal));
  }

  // Responsible for setting up four listeners to monitor the date,
  // mood, note, and save streams
  Future<bool> _startEditListeners() async {
    dateEdit.listen((date) => selectedJournal.date = date);
    moodEdit.listen((mood) => selectedJournal.mood = mood);
    noteEdit.listen((note) => selectedJournal.note = note);
    saveJournal.listen((action) {
      if (action == 'Save') _saveJournal();
    });
    return true;
  }

  // Responsible for getting a new or existing journal
  void _getJournal(bool add, Journal journal) {
    // new entry going to be created and set the default values
    if (add) {
      selectedJournal = Journal();
      selectedJournal.date = DateTime.now().toString();
      selectedJournal.mood = 'Very Satisfied';
      selectedJournal.note = '';
      selectedJournal.uid = journal.uid;
    } else {
      // an existing entry and set the default values from the passed in existing journal
      selectedJournal.date = journal.date;
      selectedJournal.mood = journal.mood;
      selectedJournal.note = journal.note;
    }

    dateEditChanged.add(selectedJournal.date);
    moodEditChanged.add(selectedJournal.mood);
    noteEditChanged.add(selectedJournal.note);
  }

  // Responsible for adding or updating a journal
  void _saveJournal() {
    Journal journal = Journal(
      documentID: selectedJournal.documentID,
      date: DateTime.parse(selectedJournal.date).toIso8601String(),
      mood: selectedJournal.mood,
      note: selectedJournal.note,
      uid: selectedJournal.uid,
    );

    add ? dbApi.addJournal(journal) : dbApi.updateJournal(journal);
  }

  void dispose() {
    _dateController.close();
    _moodController.close();
    _noteController.close();
    _saveJournalController.close();
  }
}

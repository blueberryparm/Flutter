import 'dart:math'; // Random numbers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Format Dates
import '../models/journal.dart';
import '../models/journal_edit.dart';

class EditEntry extends StatefulWidget {
  final bool add;
  final int index;
  final JournalEdit journalEdit;

  EditEntry({Key key, this.add, this.index, this.journalEdit})
      : super(key: key);

  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  JournalEdit _journalEdit;
  String _title;
  DateTime _selectedDate;
  TextEditingController _moodController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  FocusNode _moodFocus = FocusNode();
  FocusNode _noteFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _journalEdit = JournalEdit(
      action: 'Cancel',
      journal: widget.journalEdit.journal,
    );
    _title = widget.add ? 'Add' : 'Edit';
    _journalEdit.journal = widget.journalEdit.journal;
    if (widget.add) {
      _selectedDate = DateTime.now();
      _moodController.text = '';
      _noteController.text = '';
    } else {
      _selectedDate = DateTime.parse(_journalEdit.journal.date);
      _moodController.text = _journalEdit.journal.mood;
      _noteController.text = _journalEdit.journal.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title Entry'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              FlatButton(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.black54,
                      size: 22,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      DateFormat.yMMMEd().format(_selectedDate),
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black54,
                    ),
                  ],
                ),
                onPressed: () async {
                  // dismiss keyboard if any of TextField widgets have focus
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime _pickerDate = await _selectDate(_selectedDate);
                  setState(() => _selectedDate = _pickerDate);
                },
              ),
              TextField(
                controller: _moodController,
                // automatically set focus and show the keyboard when page opens
                autofocus: true,
                textInputAction: TextInputAction.next,
                focusNode: _moodFocus,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Mood',
                  icon: Icon(Icons.mood),
                ),
                onSubmitted: (submitted) {
                  // change the focus to the note TextField
                  FocusScope.of(context).requestFocus(_noteFocus);
                },
              ),
              TextField(
                controller: _noteController,
                textInputAction: TextInputAction.newline,
                focusNode: _noteFocus,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Note',
                  icon: Icon(Icons.subject),
                ),
                // grows automatically to the size of the content
                maxLines: null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    color: Colors.grey.shade100,
                    child: Text('Cancel'),
                    onPressed: () {
                      _journalEdit.action = 'Cancel';
                      Navigator.pop(context, _journalEdit);
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  FlatButton(
                    color: Colors.lightGreen[100],
                    child: Text('Save'),
                    onPressed: () {
                      _journalEdit.action = 'Save';
                      String _id = widget.add
                          ? Random().nextInt(9999999).toString()
                          : _journalEdit.journal.id;
                      _journalEdit.journal = Journal(
                        id: _id,
                        date: _selectedDate.toString(),
                        mood: _moodController.text,
                        note: _noteController.text,
                      );
                      Navigator.pop(context, _journalEdit);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _moodController.dispose();
    _noteController.dispose();
    _moodFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  /*
      Responsible for calling the Flutter built-in showDatePicker() that presents the
      user with a popup dialog displaying a Material Design calendar to choose dates
   */
  Future<DateTime> _selectDate(DateTime selectedDate) async {
    // Formatting date examples
    // print(DateFormat.d().format(DateTime.parse('2019-01-13')));
    // print(DateFormat.E().format(DateTime.parse('2019-01-13')));
    // print(DateFormat.y().format(DateTime.parse('2019-01-13')));
    // print(DateFormat.yMEd().format(DateTime.parse('2019-01-13')));
    // print(DateFormat.yMMMEd().format(DateTime.parse('2019-01-13')));
    // print(DateFormat.yMMMMEEEEd().format(DateTime.parse('2019-01-13')));
    // I/flutter (19337): 13
    // I/flutter (19337): Sun
    // I/flutter (19337): 2019
    // I/flutter (19337): Sun, 1/13/2019
    // I/flutter (19337): Sun, Jan 13, 2019
    // I/flutter (19337): Sunday, January 13, 2019

    // Formatting date examples with the add_* methods
    // print(DateFormat.yMEd().add_Hm().format(DateTime.parse('2019-01-13 10:30:15')));
    // print(DateFormat.yMd().add_EEEE().add_Hms().format(DateTime.parse('2019-01-13 10:30:15')));
    //
    // I/flutter (19337): Sun, 1/13/2019 10:30
    // I/flutter (19337): 1/13/2019 Sunday 10:30:15

    DateTime _initialDate = selectedDate;
    final DateTime _pickedDate = await showDatePicker(
      // You pass the BuildContext as the context.
      context: context,
      // You pass the journal date that is highlighted and selected in the calendar.
      initialDate: _initialDate,
      // The oldest date range available to be picked in the calendar from today's date.
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      // The newest date range available to be picked in the calendar from today's date.
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (_pickedDate != null)
      selectedDate = DateTime(
        _pickedDate.year,
        _pickedDate.month,
        _pickedDate.day,
        _initialDate.hour,
        _initialDate.minute,
        _initialDate.second,
        _initialDate.millisecond,
        _initialDate.microsecond,
      );
    return selectedDate;
  }
}

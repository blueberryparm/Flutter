/*
    Responsible for adding and editing a journal entry.
 */

import 'package:flutter/material.dart';
import '../blocs/journal_edit_bloc.dart';
import '../blocs/journal_edit_bloc_provider.dart';
import '../classes/format_dates.dart';
import '../classes/mood_icons.dart';

class EditEntry extends StatefulWidget {
  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  JournalEditBloc _journalEditBloc;
  FormatDates _formatDates;
  MoodIcons _moodIcons;
  TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates();
    _moodIcons = MoodIcons();
    _noteController = TextEditingController();
    _noteController.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _journalEditBloc = JournalEditBlocProvider.of(context).journalEditBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Entry',
          style: TextStyle(color: Colors.lightGreen.shade800),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
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
      body: SafeArea(
        minimum: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // responsible for handling the date field
              StreamBuilder(
                stream: _journalEditBloc.dateEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Container();
                  return FlatButton(
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
                          _formatDates
                              .dateFormatShortMonthDayYear(snapshot.data),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String _pickerDate = await _selectDate(snapshot.data);
                      _journalEditBloc.dateEditChanged.add(_pickerDate);
                    },
                  );
                },
              ),
              // responsible for handling the mood field
              StreamBuilder(
                stream: _journalEditBloc.moodEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Container();
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<MoodIcons>(
                      value: _moodIcons.getMoodIconsList()[_moodIcons
                          .getMoodIconsList()
                          .indexWhere((icon) => icon.title == snapshot.data)],
                      onChanged: (selected) =>
                          _journalEditBloc.moodEditChanged.add(selected.title),
                      items: _moodIcons
                          .getMoodIconsList()
                          .map((MoodIcons selected) {
                        return DropdownMenuItem(
                          value: selected,
                          child: Row(
                            children: [
                              Transform(
                                transform: Matrix4.identity()
                                  ..rotateZ(
                                    _moodIcons.getMoodRotation(selected.title),
                                  ),
                                alignment: Alignment.center,
                                child: Icon(
                                  _moodIcons.getMoodIcon(selected.title),
                                  color:
                                      _moodIcons.getMoodColor(selected.title),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(selected.title),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              // responsible for handling the note field
              StreamBuilder(
                stream: _journalEditBloc.noteEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Container();
                  // user the copyWith to make sure when you edit TextField the cursor
                  // does not bounce to the first character
                  _noteController.value =
                      _noteController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      icon: Icon(Icons.subject),
                    ),
                    maxLines: null,
                    onChanged: (note) =>
                        _journalEditBloc.noteEditChanged.add(note),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    color: Colors.grey.shade100,
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    color: Colors.lightGreen.shade100,
                    child: Text('Save'),
                    onPressed: () => _addOrUpdateJournal(),
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
    _noteController.dispose();
    _journalEditBloc.dispose();
    super.dispose();
  }

  void _addOrUpdateJournal() {
    _journalEditBloc.saveJournalChanged.add('Save');
    Navigator.pop(context);
  }

  // Responsible for calling the Flutter built-in showDatePicker() that presents the
  // user with a pop-up dialog displaying a Material Design calendar to choose dates
  Future<String> _selectDate(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);

    final DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              _initialDate.hour,
              _initialDate.minute,
              _initialDate.second,
              _initialDate.millisecond,
              _initialDate.microsecond)
          .toString();
    }
    return selectedDate;
  }
}

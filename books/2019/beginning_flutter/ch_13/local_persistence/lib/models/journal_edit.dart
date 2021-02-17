import 'journal.dart';

/*
    Handles the passing of individual journal entries between pages. The action
    variable is used to track whether the Save or Cancel is pressed. The journal
    variable contains the individual journal entry containing a Journal object
 */
class JournalEdit {
  String action;
  Journal journal;

  JournalEdit({this.action, this.journal});
}

import '../models/journal.dart';

abstract class DbApi {
  Stream<List<Journal>> getJournalList(String uid);
  Future<bool> addJournal(Journal journal);
  void updateJournal(Journal journal);
  void deleteJournal(Journal journal);
  // Future<Journal> getJournal(String documentID);
  // void updateJournalWithTransaction(Journal journal);
}

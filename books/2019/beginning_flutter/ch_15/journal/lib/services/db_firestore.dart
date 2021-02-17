import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journal.dart';
import 'db_firestore_api.dart';

// Handle the F

class DbFirestoreService implements DbApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionJournals = 'journals';

  // DbFirestoreService() {
  //   Firestore will enable the value to true by default
  //   _firestore.settings(timestampsInSnapshotsEnabled: true);
  // }

  // Responsible for retrieving journal entries. The uid is the logged-in user.
  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalDocs =
          snapshot.docs.map((doc) => Journal.fromDoc(doc)).toList();
      _journalDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
      return _journalDocs;
    });
  }

  // Responsible for adding a new journal entry
  Future<bool> addJournal(Journal journal) async {
    // holds the new document added
    DocumentReference _documentReference =
        await _firestore.collection(_collectionJournals).add(
      {
        'date': journal.date,
        'mood': journal.mood,
        'note': journal.note,
        'uid': journal.uid,
      },
    );
    // the record was created
    return _documentReference.id != null;
  }

  // Responsible for updating an existing journal entry
  void updateJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .update({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    }).catchError((error) => print('Error updating: $error'));
  }

  void deleteJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }
}

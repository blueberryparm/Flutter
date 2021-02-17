/*
    Responsible for holding individual journal entries and mapping a Cloud Firestore
    document to a Journal entry. The Journal class holds documentID, date, mood, note,
    and uid String fields. The documentID variable stores a reference to the Cloud
    Firestore database document unique ID. The uid variable stores the logged-in user
    unique ID. The date variable is formatted as an ISO 8601 standard. The mood variable
    stores the mood name like Satisfied, Neutral. The note variable stores the detailed
    journal description for the entry.
 */

class Journal {
  String documentID;
  String date;
  String mood;
  String note;
  String uid;

  Journal({this.documentID, this.date, this.mood, this.note, this.uid});

  /*
      Responsible for converting and mapping a Cloud Firestore database document
      record to an individual Journal entry.
   */
  factory Journal.fromDoc(dynamic doc) => Journal(
        documentID: doc.documentID,
        date: doc['date'],
        mood: doc['mood'],
        note: doc['note'],
        uid: doc['uid'],
      );
}

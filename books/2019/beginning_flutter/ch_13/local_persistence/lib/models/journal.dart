// Handles decoding and encoding the JSON objects for each journal entry

class Journal {
  String id;
  String date;
  String mood;
  String note;

  Journal({this.id, this.date, this.mood, this.note});

  // To retrieve and convert the JSON object to a Journal class
  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
        id: json['id'],
        date: json['date'],
        mood: json['mood'],
        note: json['note'],
      );

  // To convert the Journal class to a JSON object
  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'mood': mood,
        'note': note,
      };
}

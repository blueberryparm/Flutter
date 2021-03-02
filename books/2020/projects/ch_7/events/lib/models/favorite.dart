import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  String _id;
  String _eventId;
  String _userId;

  Favorite(this._id, this._eventId, this._userId);

  // DocumentSnapshot contains data read from a document in a
  // Cloud Firestore database
  Favorite.map(DocumentSnapshot document) {
    _id = document.id;
    _eventId = document.data()['eventId'];
    _userId = document.data()['userId'];
  }

  // Returns a map to write data to the Cloud Firestore database
  Map<String, dynamic> toMap() {
    Map map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['eventId'] = _eventId;
    map['userId'] = _userId;
    return map;
  }

  String get id => _id;
  String get eventId => _eventId;
}

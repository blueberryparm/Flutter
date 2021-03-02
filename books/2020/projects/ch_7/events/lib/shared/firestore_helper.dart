import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_detail.dart';
import '../models/favorite.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  /*
      Will take the user ID as a parameter and return a Future containing a list of
      Favorite objects. Query inside the collection with the where method. This takes
      the field where we want to apply the filter and the type of filter we need to
      apply isEqualTo and the value of the filter itself. We apply the get method to
      return an object of type QuerySnapshot that we can use to transform the result
      of the query into a list of Favorite and return it to the caller. Basically this
      will return a list containing all the favorite documents of the user whose ID
      is passed as a parameter
   */
  static Future<List<Favorite>> getUserFavorites(String uid) async {
    List<Favorite> favs = [];
    QuerySnapshot docs =
        await db.collection('favorites').where('userId', isEqualTo: uid).get();
    if (docs != null)
      favs = docs.docs.map((data) => Favorite.map(data)).toList();
    return favs;
  }

  // Will take currently logged-in user uid and the Event
  // that will be added as a favorite
  static Future addFavorite(EventDetail eventDetail, String uid) {
    Favorite fav = Favorite(null, eventDetail.id, uid);
    var result = db
        .collection('favorites')
        .add(fav.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  /*
      This will take the ID of the Favorite tha will be delete. In order to actually
      delete an item from a collection in a Cloud Firestore database, you just need to
      navigate to the collection, go to the specific document with its ID, and then
      call the delete method
   */
  static Future deleteFavorite(String favId) async =>
      db.collection('favorites').doc(favId).delete();
}

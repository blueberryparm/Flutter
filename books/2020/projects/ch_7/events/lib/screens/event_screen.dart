import 'package:events/shared/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_detail.dart';
import '../models/favorite.dart';
import '../shared/authentication.dart';
import 'login_screen.dart';

class EventScreen extends StatelessWidget {
  final String uid;
  final Authentication auth = Authentication();

  EventScreen(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => auth.signOut().then(
                  (_) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => LoginScreen(),
                    ),
                  ),
                ),
          ),
        ],
      ),
      body: EventList(uid),
    );
  }
}

class EventList extends StatefulWidget {
  final String uid;

  EventList(this.uid);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<EventDetail> details = [];
  List<Favorite> favorites = [];

  @override
  void initState() {
    if (mounted)
      getDetailsList().then((data) => setState(() => details = data));

    FirestoreHelper.getUserFavorites(widget.uid)
        .then((data) => setState(() => favorites = data));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: details != null ? details.length : 0,
      itemBuilder: (BuildContext context, int index) {
        String sub =
            'Date: ${details[index].date} - Start: ${details[index].startTime} End: ${details[index].endTime}';
        Color starColor =
            (isUserFavorite(details[index].id) ? Colors.amber : Colors.grey);
        return ListTile(
          title: Text(details[index].description),
          subtitle: Text(sub),
          trailing: IconButton(
            // icon: Icon(Icons.star, color: starColor),
            icon: Icon(
              Icons.star,
              color: starColor,
            ),
            onPressed: () => toggleFavorite(details[index]),
          ),
        );
      },
    );
  }

  // Retrieve the data
  Future<List<EventDetail>> getDetailsList() async {
    // retrieve all the documents in the event_details collection
    var data = await db.collection('event_details').get();
    int i = 0;
    if (data != null) {
      // create a list of EventDetail objects
      details =
          data.docs.map((document) => EventDetail.fromMap(document)).toList();

      details.forEach((detail) {
        print(data.docs[i].id);
        detail.id = data.docs[i].id;
        i++;
      });
    }
    return details;
  }

  void toggleFavorite(EventDetail ed) async {
    if (isUserFavorite(ed.id)) {
      Favorite favorite =
          favorites.firstWhere((Favorite f) => (f.eventId == ed.id));
      String favId = favorite.id;
      await FirestoreHelper.deleteFavorite(favId);
    } else
      await FirestoreHelper.addFavorite(ed, widget.uid);

    List<Favorite> updatedFavorites =
        await FirestoreHelper.getUserFavorites(widget.uid);
    setState(() => favorites = updatedFavorites);
  }

  /*
      The favorite variable wil contain the first Favorite whose id is equal to the
      Event Id that was passed to the function, if availanle otherwise it will return
      null
   */
  bool isUserFavorite(String eventId) {
    Favorite favorite = favorites
        .firstWhere((Favorite f) => (f.eventId == eventId), orElse: () => null);
    if (favorite == null)
      return false;
    else
      return true;
  }
}

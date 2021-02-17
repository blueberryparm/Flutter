import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

class MessagesList extends StatelessWidget {
  MessagesList(this.data);

  /*
      Is returned from a collection query, and allows you to inspect the collection,
      such as how many documents exist within it, gives access to the documents within
      the collection, see any changes since the last query.
   */
  final QuerySnapshot data;

  bool areSameDay(Timestamp a, Timestamp b) {
    var date1 = a.toDate().toLocal();
    var date2 = b.toDate().toLocal();
    return (date1.year == date2.year) &&
        (date1.month == date2.month) &&
        (date1.day == date2.day);
  }

  /*
      We’ll take the list of messages and create a ListView using the ListView.builder
      constructor, passing the data needed to show the message (sender, text, and timestamp)
      to a Message widget
   */
  @override
  Widget build(BuildContext context) => ListView.builder(
        reverse: true,
        itemCount: data.docs.length,
        itemBuilder: (context, i) {
          var months = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
          ];
          DateTime when = data.docs[i].data()["when"].toDate().toLocal();
          var widgetsToShow = <Widget>[
            FutureBuilder(
              future: FirebaseFirestore.instance
                  // If we want to access a certain document directly, we use the
                  // CollectionReference.doc(path)
                  // simple query method (where) path is actually the ID of the document,
                  // which corresponds with the path leading to the document within the collection.
                  .collection("Users")
                  // to access the documents within a QuerySnapshot, call the docs property,
                  // which returns a List containing DocumentSnapshot classes
                  .doc(data.docs[i].data()["from"])
                  // To fetch it, we need to call DocumentReference.get, which returns a
                  // Future<DocumentSnapshot>
                  .get(),
              builder: (context, snapshot) {
                // When performing a query, Firestore returns a DocumentSnapshot
                return snapshot.hasData
                    ? Message(
                        from: (snapshot.data as DocumentSnapshot).data(),
                        msg: data.docs[i].data()["msg"],
                        when: when,
                        uid: data.docs[i].data()["from"],
                      )
                    : CircularProgressIndicator();
              },
            ),
          ];
          if (i == data.docs.length - 1) {
            widgetsToShow.insert(
              0,
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "${when.day} ${months[when.month - 1]} ${when.year}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            );
          } else if (!areSameDay(
              data.docs[i + 1].data()["when"], data.docs[i].data()["when"])) {
            widgetsToShow.insert(
                0,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "${when.day} ${months[when.month - 1]} ${when.year}",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ));
          }
          return Column(children: widgetsToShow);
        },
      );
}

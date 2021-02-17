import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/messages_list.dart';
import 'login_page.dart';
import 'change_bio_page.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatOnFire"),
        actions: [
          IconButton(
            tooltip: 'Change your bio',
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeBioPage(),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Log Out',
            icon: Icon(Icons.logout),
            onPressed: () {
              _logOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: getMessages(),
              builder: (context, snapshot) => snapshot.hasData
                  ? MessagesList(snapshot.data as QuerySnapshot)
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.text,
                      onSubmitted: (txt) {
                        sendText(txt);
                        _messageController.clear();
                      }),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendText(_messageController.text);
                    _messageController.clear();
                  })
            ],
          )
        ],
      ),
    );
  }

  // get the messages as a Stream that is changed in real time to yield the list of all
  // messages updated in real time.
  // returns a Stream
  Stream<QuerySnapshot> getMessages() => FirebaseFirestore.instance
      .collection("Messages")
      .orderBy("when", descending: true)
      .snapshots();

  // add a document to a Firestore collection
  void sendText(String text) {
    User user = _auth.currentUser;
    FirebaseFirestore.instance.collection("Messages").add(
      {
        "from": user.uid,
        "when": Timestamp.fromDate(DateTime.now().toUtc()),
        "msg": text,
      },
    );
  }

  void _logOut() => _auth.signOut();
}

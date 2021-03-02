import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './screens/launch_screen.dart';
import './screens/login_screen.dart';
import './screens/event_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EventsApp());
}

class EventsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //testData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LaunchScreen(),
    );
  }

  Future testData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    // Get all the available data from the specified collection
    var data = await db.collection('event_details').get();
    var details = data.docs.toList();
    details.forEach((d) => print(d.id));
  }
}

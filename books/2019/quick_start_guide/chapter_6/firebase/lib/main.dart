import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final party = [
  {'partyname': 'BJP', 'partyvotes': 1},
  {'partyname': 'Congress', 'partyvotes': 3},
  {'partyname': 'AAP', 'partyvotes': 5},
  {'partyname': 'Janta Dal Party', 'partyvotes': 9},
  {'partyname': 'NOTA', 'partyvotes': 11},
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'State Party Elections - Worker Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Party Votes'),
      ),
      body: Center(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Votes').snapshots(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 22),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.partyname),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          title: Text(record.partyname),
          trailing: Text('${record.partyvotes}'),
          onTap: () => FirebaseFirestore.instance.runTransaction(
            (transaction) async {
              final freshFBSnapshot = await transaction.get(record.reference);
              final updated = Record.fromSnapshot(freshFBSnapshot);
              transaction.update(
                record.reference,
                {'partyvotes': updated.partyvotes + 1},
              );
            },
          ),
        ),
      ),
    );
  }
}

class Record {
  final String partyname;
  final int partyvotes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['partyname'] != null),
        assert(map['partyvotes'] != null),
        partyname = map['partyname'],
        partyvotes = map['partyvotes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => 'Record<$partyname:$partyvotes';
}

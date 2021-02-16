import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favor.dart';
import '../models/friend.dart';
import '../data/mock_values.dart';
import '../widgets/favors_list.dart';
import './login_page.dart';
import './request_favor_page.dart';

class FavorsPage extends StatefulWidget {
  FavorsPage({
    Key key,
  }) : super(key: key);

  @override
  FavorsPageState createState() => FavorsPageState();
}

class FavorsPageState extends State<FavorsPage> {
  List<Favor> pendingAnswerFavors;
  List<Favor> acceptedFavors;
  List<Favor> completedFavors;
  List<Favor> refusedFavors;
  Set<Friend> friends;

  static FavorsPageState of(BuildContext context) =>
      context.findAncestorStateOfType();

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );

    pendingAnswerFavors = [];
    acceptedFavors = [];
    completedFavors = [];
    refusedFavors = [];

    //loadFavors();
    watchFavorsCollection();
  }

  @override
  Widget build(BuildContext context) {
    var tabs = [
      _buildCategoryTab("Requests", Icons.help_outline),
      _buildCategoryTab("Doing", Icons.directions_run),
      _buildCategoryTab("Completed", Icons.done),
      _buildCategoryTab("Refused", Icons.close),
    ];

    if (Platform.isIOS) {
      return SafeArea(
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: tabs.map((i) => i as BottomNavigationBarItem).toList(),
          ),
          tabBuilder: (context, i) {
            return CupertinoTabView(builder: (context) {
              switch (i) {
                case 0:
                  return FavorsList(
                    title: "Pending Requests",
                    favors: pendingAnswerFavors,
                  );
                case 1:
                  return FavorsList(title: "Doing", favors: acceptedFavors);
                case 2:
                  return FavorsList(
                    title: "Completed",
                    favors: completedFavors,
                  );
                case 3:
                  return FavorsList(title: "Refused", favors: refusedFavors);

                default:
                  return RequestFavorPage(
                    friends: mockFriends,
                  );
              }
            });
          },
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your favors'),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs.map(((tab) => tab as Widget)).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            FavorsList(title: 'Pending Requests', favors: pendingAnswerFavors),
            FavorsList(title: 'Doing', favors: acceptedFavors),
            FavorsList(title: 'Completed', favors: completedFavors),
            FavorsList(title: 'Refused', favors: refusedFavors),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'request_favor',
          tooltip: 'Ask a favor',
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RequestFavorPage(
                friends: friends.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCategoryTab(String title, IconData iconData) {
    if (Platform.isIOS) {
      return BottomNavigationBarItem(icon: Icon(iconData), label: title);
    }
    return Tab(
      icon: Icon(iconData),
      child: Text(title),
    );
  }

  // void loadFavors() {
  //   pendingAnswerFavors.addAll(mockPendingFavors);
  //   acceptedFavors.addAll(mockDoingFavors);
  //   completedFavors.addAll(mockCompletedFavors);
  //   refusedFavors.addAll(mockRefusedFavors);
  // }

  void refuseToDo(Favor favor) =>
      _updateFavorOnFirebase(favor.copyWith(accepted: false));

  void acceptToDo(Favor favor) => _updateFavorOnFirebase(favor.copyWith(
        accepted: true,
      ));

  void giveUp(Favor favor) => _updateFavorOnFirebase(favor.copyWith(
        accepted: false,
      ));

  void complete(Favor favor) => _updateFavorOnFirebase(favor.copyWith(
        completed: DateTime.now(),
      ));

  void _updateFavorOnFirebase(Favor favor) async {
    // 1 We go to the favors collection
    // 2 Then we get the reference of the favor document that we want to update
    /*
       3 The last step is to send the data in JSON format to be updated in the
       corresponding document. The toJson() method is a simple converter
       to store on Firebase.
     */
    await FirebaseFirestore.instance
        .collection('favors')
        .doc(favor.uuid)
        .set(favor.toJson());
  }

  void watchFavorsCollection() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // 1 It starts by specifying the targeted collection
    // 2 It adds a where condition to filter the favors that are sent to
    // the current user's phone number
    // 3 snapshots() creates a stream of snapshots
    /*
       4 listen((snapshot) is where we listen for changes on the snapshots, that is
       why we subscribe to the snapshot changes. On every change on the database that
       affects the query, the function passed to listen() will be called.
     */
    FirebaseFirestore.instance
        .collection('favors')
        .where('to', isEqualTo: currentUser.phoneNumber)
        .snapshots()
        .listen((snapshot) {
      List<Favor> newCompletedFavors = [];
      List<Favor> newRefusedFavors = [];
      List<Favor> newAcceptedFavors = [];
      List<Favor> newPendingAnswerFavors = [];
      Set<Friend> newFriends = Set();

      snapshot.docs.forEach((document) {
        Favor favor = Favor.fromMap(document.id, document.data());

        if (favor.isCompleted) {
          newCompletedFavors.add(favor);
        } else if (favor.isRefused) {
          newRefusedFavors.add(favor);
        } else if (favor.isDoing) {
          newAcceptedFavors.add(favor);
        } else {
          newPendingAnswerFavors.add(favor);
        }

        newFriends.add(favor.friend);
      });

      // update our lists
      setState(() {
        this.completedFavors = newCompletedFavors;
        this.pendingAnswerFavors = newPendingAnswerFavors;
        this.refusedFavors = newRefusedFavors;
        this.acceptedFavors = newAcceptedFavors;
        this.friends = newFriends;
      });
    });
  }
}

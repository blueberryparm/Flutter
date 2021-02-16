import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/favor.dart';
import '../data/mock_values.dart';
import '../widgets/favors_list.dart';
import './request_favor_page.dart';

class FavorsPage extends StatefulWidget {
  @override
  FavorsPageState createState() => FavorsPageState();
}

class FavorsPageState extends State<FavorsPage> {
  List<Favor> pendingAnswerFavors;
  List<Favor> acceptedFavors;
  List<Favor> completedFavors;
  List<Favor> refusedFavors;

  static FavorsPageState of(BuildContext context) =>
      context.findAncestorStateOfType();

  @override
  void initState() {
    super.initState();
    pendingAnswerFavors = [];
    acceptedFavors = [];
    completedFavors = [];
    refusedFavors = [];

    loadFavors();
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
                friends: mockFriends,
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

  void loadFavors() {
    pendingAnswerFavors.addAll(mockPendingFavors);
    acceptedFavors.addAll(mockDoingFavors);
    completedFavors.addAll(mockCompletedFavors);
    refusedFavors.addAll(mockRefusedFavors);
  }

  void refuseToDo(Favor favor) {
    setState(() {
      pendingAnswerFavors.remove(favor);
      refusedFavors.add(favor.copyWith(accepted: false));
    });
  }

  void acceptToDo(Favor favor) {
    setState(() {
      pendingAnswerFavors.remove(favor);
      acceptedFavors.add(favor.copyWith(accepted: true));
    });
  }

  void giveUp(Favor favor) {
    setState(() {
      acceptedFavors.remove(favor);
      refusedFavors.add(favor.copyWith(accepted: false));
    });
  }

  void complete(Favor favor) {
    setState(() {
      acceptedFavors.remove(favor);
      completedFavors.add(favor.copyWith(completed: DateTime.now()));
    });
  }
}

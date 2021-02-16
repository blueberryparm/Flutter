import 'package:flutter/material.dart';
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your favors'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              _buildCategoryTab('Requests'),
              _buildCategoryTab('Doing'),
              _buildCategoryTab('Completed'),
              _buildCategoryTab('Refused'),
            ],
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

  Widget _buildCategoryTab(String title) => Tab(child: Text(title));

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

import 'package:flutter/material.dart';
import '../models/favors.dart';
import '../widgets/favors_list.dart';

class FavorsPage extends StatelessWidget {
  final List<Favor> pendingAnswerFavors;
  final List<Favor> acceptedFavors;
  final List<Favor> completedFavors;
  final List<Favor> refusedFavors;

  FavorsPage({
    Key key,
    this.pendingAnswerFavors,
    this.acceptedFavors,
    this.completedFavors,
    this.refusedFavors,
  }) : super(key: key);

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
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title) => Tab(child: Text(title));
}

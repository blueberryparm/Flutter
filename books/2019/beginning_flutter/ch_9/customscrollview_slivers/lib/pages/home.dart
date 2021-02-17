import 'package:flutter/material.dart';
import '../widgets/sliver_app_bar.dart';
import '../widgets/sliver_list.dart';
import '../widgets/sliver_grid.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Custom ScrollView Slivers'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBarWidget(),
          SliverListWidget(),
          SliverGridWidget(),
        ],
      ),
    );
  }
}

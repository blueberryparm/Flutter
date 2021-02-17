import 'package:flutter/material.dart';

class SliverAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceElevated: true,
      backgroundColor: Colors.brown,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Parallax Effect'),
        background: Image(
          image: AssetImage('assets/images/desk.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

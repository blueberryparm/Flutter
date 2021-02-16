import 'dart:math';

import 'package:flutter/material.dart';
import 'favor_card_item.dart';
import '../models/favor.dart';

const kFavorCardMaxWidth = 450;

class FavorsList extends StatelessWidget {
  final String title;
  final List<Favor> favors;

  const FavorsList({Key key, this.title, this.favors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text(title, style: titleStyle),
          padding: EdgeInsets.only(top: 16.0),
        ),
        Expanded(
          child: _buildCardList(context),
        ),
      ],
    );
  }

  Widget _buildCardList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardsPerRow = max(screenWidth ~/ kFavorCardMaxWidth, 1);

    if (screenWidth > 400) {
      return GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: favors.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final favor = favors[index];
          return FavorCardItem(favor: favor);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2.8,
          crossAxisCount: cardsPerRow,
        ),
      );
    }
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: favors.length,
      itemBuilder: (BuildContext context, int index) {
        final favor = favors[index];
        return FavorCardItem(favor: favor);
      },
    );
  }
}

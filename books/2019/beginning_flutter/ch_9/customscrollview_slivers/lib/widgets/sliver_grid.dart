import 'package:flutter/material.dart';

class SliverGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.child_friendly,
                  color: Colors.amber,
                  size: 48,
                ),
                Divider(),
                Text('Grid ${index + 1}'),
              ],
            ),
          );
        }, childCount: 12),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      ),
    );
  }
}

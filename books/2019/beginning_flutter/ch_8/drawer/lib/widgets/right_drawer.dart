import 'package:flutter/material.dart';
import 'menu_list_tile.dart';

class RightDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.face,
              color: Colors.white54,
              size: 128,
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          MenuListTileWidget(),
        ],
      ),
    );
  }
}

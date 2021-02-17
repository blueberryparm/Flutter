import 'package:flutter/material.dart';
import '../models/todo_menu_item.dart';

class PopupMenuButtonWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final List<TodoMenuItem> foodMenuList = [
    TodoMenuItem(title: 'Fast Food', icon: Icon(Icons.fastfood)),
    TodoMenuItem(title: 'Remind Me', icon: Icon(Icons.add_alarm)),
    TodoMenuItem(title: 'Flight', icon: Icon(Icons.flight)),
    TodoMenuItem(title: 'Music', icon: Icon(Icons.audiotrack)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      width: double.infinity,
      color: Colors.lightGreen.shade100,
      child: Center(
        child: PopupMenuButton<TodoMenuItem>(
          icon: Icon(Icons.view_list),
          onSelected: (valueSelected) =>
              print('valueSelected: ${valueSelected.title}'),
          itemBuilder: (BuildContext ctx) {
            return foodMenuList.map((TodoMenuItem todoMenuItem) {
              return PopupMenuItem<TodoMenuItem>(
                value: todoMenuItem,
                child: Row(
                  children: [
                    Icon(todoMenuItem.icon.icon),
                    Padding(padding: EdgeInsets.all(8)),
                    Text(todoMenuItem.title),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(75);
}

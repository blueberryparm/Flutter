import 'package:flutter/material.dart';
import './widgets/container_with_box_decoration_widget.dart';
import './widgets/column_widget.dart';
import './widgets/row_widget.dart';
import './widgets/column_and_row_nesting_widget.dart';
import './widgets/popup_menu_button_widget.dart';
import './widgets/buttons_widget.dart';
import './widgets/button_bar_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basics',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
          flexibleSpace: SafeArea(
            child: Icon(
              Icons.photo_camera,
              color: Colors.white70,
              size: 75,
            ),
          ),
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(75),
          //   child: Container(
          //     height: 75,
          //     width: double.infinity,
          //     color: Colors.lightGreen.shade100,
          //     child: Center(child: Text('Bottom')),
          //   ),
          // ),
          bottom: PopupMenuButtonWidget(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ContainerWithBoxDecorationWidget(),
                  Divider(),
                  ColumnWidget(),
                  Divider(),
                  RowWidget(),
                  Divider(),
                  ColumnAndRowNestingWidget(),
                  Divider(),
                  ButtonsWidget(),
                  Divider(),
                  ButtonBarWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

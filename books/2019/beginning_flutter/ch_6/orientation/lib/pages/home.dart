import 'package:flutter/material.dart';
import 'package:orientation/widgets/orientation_builder_widget.dart';
import '../widgets/orientation_layout_icon_widget.dart';
import '../widgets/orientation_layout_widget.dart';
import '../widgets/gridview_widget.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orientation'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                OrientationLayoutIconsWidget(),
                Divider(),
                OrientationLayoutWidget(),
                Divider(),
                GridViewWidget(),
                Divider(),
                OrientationBuilderWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Cupertino Widgets Demo',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final data = [
    {'Train', CupertinoIcons.train_style_one},
    {'Search', CupertinoIcons.search},
    {'Share', CupertinoIcons.share},
  ];
  
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: data
            .map((e) =>
                BottomNavigationBarItem(label: e.first, icon: Icon(e.last)))
            .toList(),
      ),
      tabBuilder: (context, i) => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(data[i].first),
          ),
          child: Center(
            child: Icon(
              data[i].last,
              size: 80,
            ),
          ),
        ),
      ),
    );
  }
}

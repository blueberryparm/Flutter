import 'package:flutter/material.dart';

class Themes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Text('body1', style: Theme.of(context).textTheme.bodyText2),
            Text('body2', style: Theme.of(context).textTheme.bodyText1),
            Text('button', style: Theme.of(context).textTheme.button),
            Text('caption', style: Theme.of(context).textTheme.caption),
            Text('display1', style: Theme.of(context).textTheme.headline4),
            Text('display2', style: Theme.of(context).textTheme.headline3),
            Text('display3', style: Theme.of(context).textTheme.headline2),
            Text('display4', style: Theme.of(context).textTheme.headline1),
            Text('headline', style: Theme.of(context).textTheme.headline5),
            Text('overline', style: Theme.of(context).textTheme.overline),
            Text('subhead', style: Theme.of(context).textTheme.subtitle1),
            Text('subtitle', style: Theme.of(context).textTheme.subtitle2),
            Text('title', style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
    );
  }
}

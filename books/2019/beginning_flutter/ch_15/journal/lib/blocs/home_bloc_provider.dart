/*
    Responsible for passing the State between widgets and pages by using the
    InheritedWidget class as a provider
 */

import 'package:flutter/material.dart';
import 'home_bloc.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;

  const HomeBlocProvider({Key key, Widget child, this.homeBloc, this.uid})
      : super(key: key, child: child);

  // Gets the instance of the HomeBlocProvider provider
  static HomeBlocProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  // Checks whether the value has changed, and the framework notifies the widgets to rebuild
  @override
  bool updateShouldNotify(HomeBlocProvider old) => homeBloc != old.homeBloc;
}

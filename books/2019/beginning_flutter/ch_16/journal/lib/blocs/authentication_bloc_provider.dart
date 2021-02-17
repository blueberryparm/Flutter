/*
    Responsible for passing the State between widgets and pages by using the
    InheritedWidget class as a provider
 */

import 'package:flutter/material.dart';
import 'authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AutheticationBloc autheticationBloc;

  const AuthenticationBlocProvider(
      {Key key, Widget child, this.autheticationBloc})
      : super(key: key, child: child);

  // Gets the instance of the AutheticationBlocProvider provider
  static AuthenticationBlocProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  // Checks whether the value has changed, and the framework notifies the widgets to rebuild
  @override
  bool updateShouldNotify(AuthenticationBlocProvider old) =>
      autheticationBloc != old.autheticationBloc;
}

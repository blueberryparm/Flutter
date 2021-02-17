/*
    Responsible for passing the State between widgets and pages by using the
    InheritedWidget class as a provider
 */

import 'package:flutter/material.dart';
import 'journal_edit_bloc.dart';

class JournalEditBlocProvider extends InheritedWidget {
  final JournalEditBloc journalEditBloc;

  const JournalEditBlocProvider({Key key, Widget child, this.journalEditBloc})
      : super(key: key, child: child);

  // Gets the instance of the JournalEditBlocProvider provider
  static JournalEditBlocProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  // Checks whether the value has changed, and the framework notifies the widgets to rebuild
  @override
  bool updateShouldNotify(JournalEditBlocProvider old) =>
      journalEditBloc != old.journalEditBloc;
}

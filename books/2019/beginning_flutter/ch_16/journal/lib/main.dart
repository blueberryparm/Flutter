import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './blocs/authentication_bloc.dart';
import './blocs/authentication_bloc_provider.dart';
import './blocs/home_bloc.dart';
import './blocs/home_bloc_provider.dart';
import './services/authentication.dart';
import './services/db_firestore.dart';
import './pages/home.dart';
import './pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService =
        AuthenticationService();
    final AutheticationBloc _authenticationBloc =
        AutheticationBloc(_authenticationService);

    return AuthenticationBlocProvider(
      autheticationBloc: _authenticationBloc,
      child: StreamBuilder(
        // no user is logged in
        initialData: null,
        // rebuilds every time the user's authentication status changes
        // and navigates the user to the appropriate login or home page
        stream: _authenticationBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          else if (snapshot.hasData)
            // user logs in with the correct credentials
            return HomeBlocProvider(
              // injecting Flutter platform service classes
              homeBloc: HomeBloc(DbFirestoreService(), _authenticationService),
              uid: snapshot.data,
              child: _buildMaterialApp(Home()),
            );
          else
            return _buildMaterialApp(Login());
        },
      ),
    );
  }

  MaterialApp _buildMaterialApp(Widget homePage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        canvasColor: Colors.lightGreen.shade50,
        bottomAppBarColor: Colors.lightGreen,
      ),
      home: homePage,
    );
  }
}

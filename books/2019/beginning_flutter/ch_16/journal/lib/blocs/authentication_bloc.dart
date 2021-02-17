/*
    Responsible for identifying logged-in user credentials and monitoring
    user authentication login status.
 */

import 'dart:async';
import '../services/authentication_api.dart';

class AutheticationBloc {
  final AuthenticationApi authenticationApi;

  final StreamController<String> _autheticationController =
      StreamController<String>();
  // Every time the user logs in or logs out is updated
  StreamSink<String> get addUser => _autheticationController.sink;
  Stream<String> get user => _autheticationController.stream;

  final StreamController<bool> _logoutController = StreamController<bool>();
  StreamSink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AutheticationBloc(this.authenticationApi) {
    onAuthChanged();
  }

  // Responsible for setting up a listener to check when the user logs in and logs out
  void onAuthChanged() {
    authenticationApi
        .getFirebaseAuth() // get the firebase instance
        .authStateChanges()
        .listen((user) {
      // when the user logs in, the user variable returns a Firebase User with the
      // user information. When the user logs out, the user variable returns null
      final String uid = user != null ? user.uid : null;
      addUser.add(uid);
    });

    // Called when the user logs out
    _logoutController.stream.listen((logout) {
      if (logout) _signOut();
    });
  }

  // Responsible for logging out the user
  void _signOut() => authenticationApi.signOut();

  void dispose() {
    _autheticationController.close();
    _logoutController.close();
  }
}

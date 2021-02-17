/*
    Responsible for monitoring the login page to check for a valid email
    format and password length. When instantiated it starts to monitor the
    user's email and password, and once they pass validation, the login and
    create account buttons are enabled. Once the login and password values
    pass validation, the authentication service is called to log in or
    create a new user.
 */

import 'dart:async';

import '../classes/validators.dart';
import '../services/authentication_api.dart';

class LoginBloc with Validators {
  final AuthenticationApi authenticationApi;
  String _email;
  String _password;
  bool _emailValid;
  bool _passwordValid;

  final StreamController<String> _emailController =
      StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final StreamController<String> _passwordController =
      StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  final StreamController<bool> _enableLoginCreateButtonController =
      StreamController<bool>.broadcast();
  Sink<bool> get enableLoginCreateButtonChanged =>
      _enableLoginCreateButtonController.sink;
  Stream<bool> get enableLoginCreateButton =>
      _enableLoginCreateButtonController.stream;

  final StreamController<String> _loginOrCreateButtonController =
      StreamController<String>();
  Sink<String> get loginOrCreateButtonChanged =>
      _loginOrCreateButtonController.sink;
  Stream<String> get loginOrCreateButton =>
      _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController =
      StreamController<String>();
  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  LoginBloc(this.authenticationApi) {
    _startListenersIfEmailPasswordAreValid();
  }

  // Responsible for setting up three listeners that check the email, password,
  // and login or create streams
  void _startListenersIfEmailPasswordAreValid() {
    email.listen((email) {
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _email = '';
      _emailValid = false;
      _updateEnableLoginCreateButtonStream();
    });

    password.listen((password) {
      _password = password;
      _passwordValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _password = '';
      _passwordValid = false;
      _updateEnableLoginCreateButtonStream();
    });

    loginOrCreate
        .listen((action) => action == 'Login' ? _login() : _createAccount());
  }

  // The results of the value being added to the sink property either enable
  // or disable the login or create account button
  void _updateEnableLoginCreateButtonStream() {
    if (_emailValid && _passwordValid)
      enableLoginCreateButtonChanged.add(true);
    else
      enableLoginCreateButtonChanged.add(false);
  }

  // Responsible for logging in a user with the email/password credentials
  Future<String> _login() async {
    String _result = '';
    if (_emailValid && _passwordValid) {
      await authenticationApi
          .signInWithEmailAndPassword(_email, _password)
          .then((user) {
        _result = 'Success';
      }).catchError((error) {
        print('Login error: $error');
        _result = 'Error';
      });
      // Returns a status that the login has been successful or return the login error
      return _result;
    } else {
      return 'Email and Password are not valid';
    }
  }

  // Responsible for creating a new account and if successful automatically
  // logging in the new user.
  Future<String> _createAccount() async {
    String _result = '';
    if (_emailValid && _passwordValid) {
      await authenticationApi
          .createUserWithEmailAndPassword(_email, _password)
          .then((user) {
        print('Created user: $user');
        _result = 'Created user: $user';
        // When a new account is created, it's a good practice to automatically
        // log in the new user
        authenticationApi
            .signInWithEmailAndPassword(_email, _password)
            .then((user) {})
            .catchError((error) async {
          print('Login error: $error');
          _result = error;
        });
      }).catchError((error) async {
        print('Creating User error: $error');
      });
      // Returns a status that the login has been successful or return the login error
      return _result;
    } else {
      return 'Error creating user';
    }
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _enableLoginCreateButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isVerificationComplete = false;

  UserCredential _userCredential;

  @override
  Widget build(BuildContext context) {
    if (_isVerificationComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConfigPage(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ChatOnFire Login'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Log In Using Your Phone Number',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Email Address',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: FlatButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: Text('Log In'.toUpperCase()),
              onPressed: () =>
                  logIn(_emailController.text, _passwordController.text)
                      .then((user) {
                _userCredential = user;
                if (!_userCredential.user.emailVerified)
                  _userCredential.user.sendEmailVerification();
                _isVerificationComplete = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfigPage(),
                  ),
                );
              }).catchError(
                (e) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You don\'t have an account: Please sign up'),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: FlatButton(
              color: Theme.of(context).hintColor,
              textColor: Colors.white,
              child: Text('Create an Account'.toUpperCase()),
              onPressed: () async {
                try {
                  _userCredential = await signUp(
                      _emailController.text, _passwordController.text);
                  if (!_userCredential.user.emailVerified)
                    _userCredential.user.sendEmailVerification();
                  _isVerificationComplete = true;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigPage(),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('An error occurred'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<UserCredential> logIn(String email, String password) async =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signUp(String email, String password) async =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);
}

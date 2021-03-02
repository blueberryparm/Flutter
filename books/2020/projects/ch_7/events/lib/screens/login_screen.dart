import 'package:flutter/material.dart';
import '../shared/authentication.dart';
import 'event_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Authentication auth;
  bool _isLogin = true;
  String _userId;
  String _message;
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                emailInput(),
                passwordInput(),
                mainButton(),
                secondaryButton(),
                if (_message != null) validationMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future submit() async {
    setState(() => _message = '');
    try {
      if (_isLogin) {
        _userId = await auth.login(txtEmail.text, txtPassword.text);
        print('Login for user $_userId');
      } else {
        _userId = await auth.signUp(txtEmail.text, txtPassword.text);
        print('Sign up fo user $_userId');
      }

      if (_userId != null)
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => EventScreen(_userId)));
    } catch (e) {
      print('Error: $e');
      setState(() => _message = e.message);
    }
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'email',
          icon: Icon(Icons.mail),
        ),
        validator: (text) => text.isEmpty ? 'Email is required' : null,
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'password',
          icon: Icon(Icons.enhanced_encryption),
        ),
        validator: (text) => text.isEmpty ? 'Password is required' : null,
      ),
    );
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: Container(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            primary: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(buttonText),
          onPressed: submit,
        ),
      ),
    );
  }

  Widget secondaryButton() {
    String buttonText = !_isLogin ? 'Login' : 'Sign up';
    return TextButton(
      child: Text(buttonText),
      onPressed: () => setState(() => _isLogin = !_isLogin),
    );
  }

  Widget validationMessage() {
    return Text(
      _message,
      style: TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

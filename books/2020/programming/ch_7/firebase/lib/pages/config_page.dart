import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';

class ConfigPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure your account\'s basic information'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Display Name',
            ),
          ),
          TextField(
            controller: _bioController,
            decoration: InputDecoration(
              labelText: 'Bio',
            ),
          ),
          FlatButton(
            child: Text('Submit'),
            onPressed: () => setDataAndGoToChatPage(
              context,
              _nameController.text,
              _bioController.text,
            ),
          ),
        ],
      ),
    );
  }

  void setDataAndGoToChatPage(
      BuildContext context, String name, String bio) async {
    final firebase = FirebaseAuth.instance;
    final user = firebase.currentUser;
    user.updateProfile(displayName: name);
    //user.reload();

    // add document to the Users collection
    FirebaseFirestore.instance.collection('Users').doc(user.uid).set(
      {
        'displayName': name,
        'email': user.email,
        'bio': bio,
      },
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(),
      ),
    );
  }
}

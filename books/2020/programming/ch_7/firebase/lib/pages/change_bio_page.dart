import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeBioPage extends StatelessWidget {
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change your bio'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'New Bio',
                ),
                onSubmitted: (bio) {
                  _changeBio(bio);
                  Navigator.pop(context);
                },
              ),
            ),
            FlatButton(
              child: Text('Change Bio'),
              onPressed: () {
                _changeBio(_bioController.text);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeBio(String bio) {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('Users').doc(user.uid).update(
      {'bio': bio},
    );
  }
}

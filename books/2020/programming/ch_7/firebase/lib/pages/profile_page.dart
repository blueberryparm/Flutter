import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;

  ProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              user['displayName'],
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              user['bio'],
              style: Theme.of(context).textTheme.subtitle2,
            ),
            FlatButton.icon(
              label: Text("Send an e-mail to ${user['displayName']}"),
              icon: Icon(Icons.email),
              onPressed: () async {
                var url =
                    "mailto:${user['email']}?body=${user['displayName']},\n";
                if (await canLaunch(url))
                  launch(url);
                else
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You don't have any e-mail app"),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

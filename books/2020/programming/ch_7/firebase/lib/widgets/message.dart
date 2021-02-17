import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/profile_page.dart';

class Message extends StatelessWidget {
  Message({this.uid, this.from, this.msg, this.when});

  final User user = FirebaseAuth.instance.currentUser;
  final String uid;
  final Map<String, dynamic> from;
  final String msg;
  final DateTime when;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: user.uid == uid ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 2 / 3,
        child: Card(
            shape: StadiumBorder(),
            child: ListTile(
              title: user.uid != uid
                  ? InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 5.0),
                        child: Text(
                          from["displayName"],
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(from),
                        ),
                      ),
                    )
                  : InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          'You',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(from),
                        ),
                      ),
                    ),
              subtitle: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, left: 5.0),
                child: Text(msg, style: Theme.of(context).textTheme.bodyText2),
              ),
              trailing: Text("${when.hour}​:​${when.minute}"),
            )),
      ),
    );
  }
}

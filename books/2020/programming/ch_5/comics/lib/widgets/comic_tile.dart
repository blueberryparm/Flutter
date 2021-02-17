import 'dart:io';

import 'package:flutter/material.dart';
import '../pages/comic_page.dart';

class ComicTile extends StatelessWidget {
  final Map<String, dynamic> comic;

  ComicTile({this.comic});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.file(
        File(
          comic['img'],
        ),
        height: 30,
        width: 30,
      ),
      title: Text(comic['title']),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ComicPage(comic),
        ),
      ),
    );
  }
}

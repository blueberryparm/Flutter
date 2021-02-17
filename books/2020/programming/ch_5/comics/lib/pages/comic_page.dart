import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ComicPage extends StatefulWidget {
  final Map<String, dynamic> comic;

  ComicPage(this.comic);

  @override
  _ComicPageState createState() => _ComicPageState();
}

class _ComicPageState extends State<ComicPage> {
  String docsDir;
  bool isStarred = false;

  @override
  void initState() {
    super.initState();
    // determine whether or not the comic is starred when we load the ComicPage for the first time
    // since we will be changing that variable's value whenever the user taps on the star button
    getApplicationDocumentsDirectory().then((dir) {
      docsDir = dir.path;
      var file = File('$docsDir/starred');
      if (!file.existsSync()) {
        file.createSync();
        file.writeAsStringSync('[]');
        isStarred = false;
      } else
        setState(() => isStarred = _isStarred(widget.comic['num']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#${widget.comic['num']}"),
        actions: [
          IconButton(
            tooltip: 'Star Comic',
            icon: Icon(
              isStarred ? Icons.star : Icons.star_border,
            ),
            onPressed: () {
              _addToStarred(widget.comic['num']);
              setState(() => isStarred = !isStarred);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              widget.comic['title'],
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          InkWell(
            child: Image.file(
              File(widget.comic['img']),
            ),
            onTap: () => _launchComic(widget.comic['num']),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(widget.comic['alt']),
          ),
        ],
      ),
    );
  }

  void _launchComic(int comicNumber) =>
      launch('https://xkcd.com/$comicNumber/');

  void _addToStarred(int num) {
    var file = File('$docsDir/starred');
    List<int> savedComics = json.decode(file.readAsStringSync()).cast<int>();

    if (isStarred)
      savedComics.remove(num);
    else
      savedComics.add(num);
    file.writeAsStringSync(json.encode(savedComics));
  }

  // Checks if the comic has been starred by opening the file containing the starred comic numbers
  bool _isStarred(int num) {
    var file = File('$docsDir/starred');
    List<int> savedComics = json.decode(file.readAsStringSync()).cast<int>();

    if (savedComics.indexOf(num) != -1)
      return true;
    else
      return false;
  }
}

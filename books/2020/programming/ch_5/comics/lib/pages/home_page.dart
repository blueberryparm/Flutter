import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../widgets/comic_tile.dart';
import 'selection_page.dart';
import 'starred_page.dart';

class HomePage extends StatelessWidget {
  final String title;
  final int latestComic;

  HomePage({this.title, this.latestComic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Select Comics by Number',
            icon: Icon(Icons.looks_one),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SelectionPage(),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Browse Starred Comics',
            icon: Icon(Icons.star),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => StarredPage(),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: latestComic,
        itemBuilder: (context, index) => FutureBuilder(
          future: _fetchComic(index),
          builder: (context, comicResult) => comicResult.hasData
              ? ComicTile(
                  comic: comicResult.data,
                )
              : Container(
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchComic(int n,
      {http.Client httpClient,
      File comicFile,
      File imageFile,
      String imagePath}) async {
    int comicNumber = latestComic - n;
    Directory dir;

    if (httpClient == null) {
      httpClient = http.Client();
    }

    if (comicFile == null) {
      dir = await getTemporaryDirectory();
      comicFile = File('${dir.path}/$comicNumber.json');
    }

    if (imageFile == null) {
      if (dir == null) dir = await getTemporaryDirectory();
      imagePath = '${dir.path}/$comicNumber.json';
      imageFile = File(imagePath);
    }

    // check if the file exists and isn't empty and return its decoded content
    if (await comicFile.exists() && comicFile.readAsStringSync() != '')
      return json.decode(comicFile.readAsStringSync());
    else {
      // if it isn't, we need to create the file and write the JSON string to it
      comicFile.createSync();
      final comic = json.decode(
          await httpClient.read('https://xkcd.com/$comicNumber/info.0.json'));

      File('${dir.path}/$comicNumber.png')
          .writeAsBytesSync(await httpClient.readBytes(comic['img']));
      comic['img'] = '${dir.path}/$comicNumber.png';
      comicFile.writeAsString(json.encode(comic));

      return comic;
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'comic_page.dart';
import 'error_page.dart';

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comic selection'),
      ),
      body: Center(
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Insert comic #',
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
          onSubmitted: (String value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FutureBuilder(
                  future: fetchComics(value),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return ErrorPage();
                    if (snapshot.hasData) return ComicPage(snapshot.data);
                    return CircularProgressIndicator();
                  },
                ),
              )),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchComics(String n,
      {http.Client httpClient,
      File comicFile,
      File imageFile,
      String imagePath}) async {
    Directory dir;

    if (httpClient == null) {
      httpClient = http.Client();
    }

    if (comicFile == null) {
      dir = await getTemporaryDirectory();
      comicFile = File('${dir.path}/$n.json');
    }

    if (imageFile == null) {
      if (dir == null) dir = await getTemporaryDirectory();
      imagePath = '${dir.path}/$n.png';
      imageFile = File(imagePath);
    }

    if (await comicFile.exists() && comicFile.readAsStringSync() != '')
      return json.decode(comicFile.readAsStringSync());
    else {
      comicFile.createSync();
      final comic =
          json.decode(await httpClient.read('https://xkcd.com/$n/info.0.json'));
      File('${dir.path}/$n.png')
          .writeAsBytesSync(await httpClient.readBytes(comic['img']));
      comic['img'] = '${dir.path}/$n.png';
      comicFile.writeAsString(json.encode(comic));

      return comic;
    }
  }
}

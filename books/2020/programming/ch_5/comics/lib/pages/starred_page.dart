import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../widgets/comic_tile.dart';

class StarredPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var comics = _retrieveSavedComics();

    return Scaffold(
      appBar: AppBar(
        title: Text('Browse your Favorite Comics'),
      ),
      body: FutureBuilder(
        future: comics,
        builder: (context, snapshot) =>
            snapshot.hasData && snapshot.data.isNotEmpty
                // if there are any starred comics
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => ComicTile(
                      comic: snapshot.data[index],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.not_interested),
                      Text(
                        """
                You haven't starred any comics yet.
                Check back after you have found something worthy of being here.
                """,
                      ),
                    ],
                  ),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchComics(String n,
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

  Future<List<Map<String, dynamic>>> _retrieveSavedComics() async {
    // 1 fetch the application documents directory and use it to define
    // the file which we will be operating on
    Directory docsDir = await getApplicationDocumentsDirectory();
    File file = File('${docsDir.path}/starred');
    List<Map<String, dynamic>> comics = [];

    // 2 Check whether the starred comics exist, if it doesn't, we just create the file and
    // end up returning an empty list
    if (!file.existsSync()) {
      file.createSync();
      file.writeAsStringSync('[]');
    } else
      // 3 The file exists, we fetch all of the comics listed in the file and return them
      json.decode(file.readAsStringSync()).forEach(
            (n) async => comics.add(
              await _fetchComics(
                n.toString(),
              ),
            ),
          );

    return comics;
  }
}

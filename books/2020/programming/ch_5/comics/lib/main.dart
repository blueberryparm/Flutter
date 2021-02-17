import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import './pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'XKCD app',
    home: HomePage(
      title: 'XKCD',
      latestComic: await getLatestComicNumber(),
    ),
  ));
}

Future<int> getLatestComicNumber(
    {http.Client httpClient, File latestComicNFile}) async {
  if (httpClient == null) {
    httpClient = http.Client();
  }

  if (latestComicNFile == null) {
    final dir = await getTemporaryDirectory();
    latestComicNFile = File('${dir.path}/latestComicNumber.txt');
  }

  int n = 1;

  try {
    n = json.decode(await http.read('https://xkcd.com/info.0.json'))['num'];
    latestComicNFile.exists().then((exists) {
      if (!exists) latestComicNFile.createSync();
      latestComicNFile.writeAsString('$n');
    });
  } catch (e) {
    if (latestComicNFile.existsSync() &&
        latestComicNFile.readAsStringSync() != '')
      n = int.parse(latestComicNFile.readAsStringSync());
  }
  return n;
}

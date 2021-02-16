import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './models/post.dart';

void main() => runApp(
      MyApp(
        post: fetchPost(),
      ),
    );

class MyApp extends StatelessWidget {
  final Future<Post> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JSON Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(snapshot.data.movieName);
              else if (snapshot.hasError) return Text('${snapshot.error}');
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

Future<Post> fetchPost() async {
  // change json-server --watch db.json --host 0.0.0.0
  final baseUrl = 'http://192.168.1.74:3000';
  final response = await http.get('$baseUrl/Movies/1');
  if (response.statusCode == 200)
    return Post.fromJson(json.decode(response.body));
  else
    throw Exception('Failed to load post');
}

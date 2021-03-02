import 'package:flutter/material.dart';
import './pages/movie_list_page.dart';

void main() => runApp(MyMovies());

class MyMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Movies',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: MovieListPage(),
    );
  }
}

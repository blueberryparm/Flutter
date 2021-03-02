import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailPage extends StatelessWidget {
  final String imgPath = 'https://image.tmdb.org/t/p/w500/';
  final Movie movie;

  MovieDetailPage({this.movie});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String path;
    if (movie.posterPath != null)
      path = imgPath + movie.posterPath;
    else
      path =
          'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                height: height / 1.5,
                child: Image.network(path),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(movie.overview),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

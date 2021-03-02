// Responsible to connect to the web service
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/movie.dart';

class HttpHelper {
  final String urlKey = 'api_key=2195ef5524af4fcc009889519c61adfa';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?api_key=2195ef5524af4fcc009889519c61adfa&query=';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';

  // Return a list of 20 upcoming movies
  Future<List> getUpcoming() async {
    final String upcoming = '$urlBase$urlUpcoming$urlKey$urlLanguage';
    http.Response result = await http.get(upcoming);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } else
      return null;
  }

  Future<List> findMovies(String title) async {
    final String query = urlSearchBase + title;
    http.Response result = await http.get(query);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = jsonDecode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    } else
      return null;
  }
}

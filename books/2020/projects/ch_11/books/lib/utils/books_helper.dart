import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../pages/favorites_page.dart';

class BooksHelper {
  final String urlKey = '&key=AIzaSyDXxIKpHEBXdYe6e8TruKaTiviYpHhuYaE';
  final String urlQuery = 'volumes?q=';
  final String urlBase = 'https://www.googleapis.com/books/v1/';

  Future<List<dynamic>> getBooks(String query) async {
    final String url = urlBase + urlQuery + query + urlKey;
    // retrieve the books data
    http.Response result = await http.get(url);

    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      // we need a node called items from the body which contains the volume's info
      final booksMap = jsonResponse['items'];
      // for each volume in the items node, create a Book object from the JSON object
      // then return a list of the books that were created
      List<dynamic> books = booksMap.map((i) => Book.fromJson(i)).toList();
      return books;
    } else
      return null;
  }

  // Returns a list of books that we retrieve from SharedPreferences
  Future<List<dynamic>> getFavorites() async {
    // returns the favorite books or an empty list
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<dynamic> favBooks = [];
    Set allKeys = preferences.getKeys();
    if (allKeys.isNotEmpty)
      for (int i = 0; i < allKeys.length; i++) {
        String key = (allKeys.elementAt(i).toString());
        String value = preferences.get(key);
        dynamic json = jsonDecode(value);
        Book book = Book(
          json['id'],
          json['title'],
          json['authors'],
          json['description'],
          json['publisher'],
        );
        favBooks.add(book);
      }
    return favBooks;
  }

  Future addToFavorites(Book book) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // check if the book already exists in the local storage
    String id = preferences.getString(book.id);
    if (id != '')
      await preferences.setString(
        book.id,
        json.encode(
          book.toJson(),
        ),
      );
  }

  Future removeFromFavorites(Book book, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // check if the book already exists in the local storage
    String id = preferences.getString(book.id);
    if (id != '') {
      await preferences.remove(book.id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritesPage(),
        ),
      );
    }
  }
}

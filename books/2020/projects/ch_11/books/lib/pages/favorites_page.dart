import 'package:flutter/material.dart';
import '../utils/books_helper.dart';
import 'home_page.dart';
import 'ui.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  BooksHelper helper;
  List<dynamic> books = [];
  int booksCount;

  @override
  void initState() {
    helper = BooksHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isSmall = false;
    if (width < 600) isSmall = true;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Favorite Books'),
        actions: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: isSmall ? Icon(Icons.home) : Text('Home'),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: isSmall ? Icon(Icons.star) : Text('Favorites'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text('My Favorite Books'),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: isSmall ? BooksList(books, true) : BooksTable(books, true),
            ),
          ],
        ),
      ),
    );
  }

  Future initialize() async {
    books = await helper.getFavorites();
    setState(() {
      booksCount = books.length;
      books = books;
    });
  }
}

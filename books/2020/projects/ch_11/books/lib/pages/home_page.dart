import 'package:flutter/material.dart';
import '../utils/books_helper.dart';
import 'favorites_page.dart';
import 'ui.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BooksHelper helper;
  List<dynamic> books = [];
  int booksCount;
  TextEditingController txtSearchController;

  @override
  void initState() {
    helper = BooksHelper();
    txtSearchController = TextEditingController();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;
    if (MediaQuery.of(context).size.width < 600) isSmall = true;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Books'),
        actions: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: isSmall ? Icon(Icons.home) : Text('Home'),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: isSmall ? Icon(Icons.star) : Text('Favorites'),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesPage(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('Search Book'),
                  Expanded(
                    child: TextField(
                      controller: txtSearchController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (text) => helper.getBooks(text).then(
                            (value) => setState(() => books = value),
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => helper.getBooks(txtSearchController.text),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child:
                  isSmall ? BooksList(books, false) : BooksTable(books, false),
            ),
          ],
        ),
      ),
    );
  }

  Future initialize() async {
    books = await helper.getBooks('flutter');
    setState(() {
      booksCount = books.length;
      books = books;
    });
  }
}

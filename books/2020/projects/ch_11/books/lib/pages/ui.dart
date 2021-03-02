import 'package:flutter/material.dart';
import '../utils/books_helper.dart';

class BooksTable extends StatelessWidget {
  final List<dynamic> books;
  final bool isFavorite;
  final BooksHelper helper = BooksHelper();

  BooksTable(this.books, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.blueGrey),
      columnWidths: {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
      },
      children: books.map((book) {
        return TableRow(
          children: [
            TableCell(
              child: TableText(book.title),
            ),
            TableCell(
              child: TableText(book.authors),
            ),
            TableCell(
              child: TableText(book.publisher),
            ),
            TableCell(
              child: IconButton(
                color: isFavorite ? Colors.red : Colors.amber,
                tooltip:
                    isFavorite ? 'Remove from favorites' : 'Add to favorites',
                icon: Icon(Icons.star),
                onPressed: () {
                  if (isFavorite)
                    helper.removeFromFavorites(book, context);
                  else
                    helper.addToFavorites(book);
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class TableText extends StatelessWidget {
  final String text;

  TableText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
      ),
    );
  }
}

class BooksList extends StatelessWidget {
  final List<dynamic> books;
  final bool isFavorite;
  final BooksHelper helper = BooksHelper();

  BooksList(this.books, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 1.4;
    final int booksCount = books.length;

    return Container(
      height: height,
      child: ListView.builder(
        itemCount: booksCount == null ? 0 : booksCount,
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(books[index].title),
          subtitle: Text(books[index].authors),
          trailing: IconButton(
            color: isFavorite ? Colors.red : Colors.amber,
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            icon: Icon(Icons.star),
            onPressed: () {
              if (isFavorite)
                helper.removeFromFavorites(books[index], context);
              else
                helper.addToFavorites(books[index]);
            },
          ),
        ),
      ),
    );
  }
}

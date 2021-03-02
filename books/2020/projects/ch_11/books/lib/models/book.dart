class Book {
  String id;
  String title;
  String authors;
  String description;
  String publisher;

  Book(this.id, this.title, this.authors, this.description, this.publisher);

  factory Book.fromJson(Map<String, dynamic> parsedJson) {
    final String id = parsedJson['id'];
    final String title = parsedJson['volumeInfo']['title'];
    // transform json array into a string
    String authors = (parsedJson['volumeInfo']['authors'] == null)
        ? ''
        : parsedJson['volumeInfo']['authors'].toString();
    // we remove the square brackets
    authors = authors.replaceAll('[', '');
    authors = authors.replaceAll(']', '');
    final description = (parsedJson['searchInfo']['textSnippet'] == null)
        ? ''
        : parsedJson['searchInfo']['textSnippet'];
    final String publisher = (parsedJson['volumeInfo']['publisher'] == null)
        ? ''
        : parsedJson['volumeInfo']['publisher'];
    return Book(id, title, authors, description, publisher);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'description': description,
        'publisher': publisher,
      };
}

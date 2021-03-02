import 'package:flutter/material.dart';
import '../utils/http_helper.dart';
import 'movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  HttpHelper helper;
  String result;
  int moviesCount;
  List movies;
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;

    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: [
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (visibleIcon.icon == Icons.search) {
                  visibleIcon = Icon(Icons.cancel);
                  searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    onSubmitted: (String text) => search(text),
                  );
                } else {
                  setState(() {
                    visibleIcon = Icon(Icons.search);
                    searchBar = Text('Movies');
                  });
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: moviesCount == 0 ? 0 : moviesCount,
        itemBuilder: (BuildContext context, int index) {
          if (movies[index].posterPath != null)
            image = NetworkImage(iconBase + movies[index].posterPath);
          else
            image = NetworkImage(defaultImage);
          return Card(
            elevation: 2,
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: image,
              ),
              title: Text(movies[index].title),
              subtitle: Text(
                'Released: ${movies[index].releaseDate} - Votes: ${movies[index].voteAverage}',
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(
                    movie: movies[index],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future initialize() async {
    movies = [];
    movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  Future search(String text) async {
    movies = await helper.findMovies(text);
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }
}

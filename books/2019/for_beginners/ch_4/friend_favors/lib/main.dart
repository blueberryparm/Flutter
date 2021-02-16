import 'package:flutter/material.dart';
import './screens/favors_page.dart';
//import './screens/request_favor_page.dart';
import './data/mock_values.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friend Favors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FavorsPage(
        pendingAnswerFavors: mockPendingFavors,
        acceptedFavors: mockDoingFavors,
        completedFavors: mockCompletedFavors,
        refusedFavors: mockRefusedFavors,
      ),
      // home: RequestFavorPage(
      //   friends: mockFriends,
      // ),
    );
  }
}

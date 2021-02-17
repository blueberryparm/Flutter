import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Layouts',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black54),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: [IconButton(icon: Icon(Icons.cloud_queue), onPressed: () {})],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() => SingleChildScrollView(
        child: Column(
          children: [
            _buildJournalHeaderImage(),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildJournalEntry(),
                    _buildJournalWeather(),
                    _buildJournalTags(),
                    _buildJournalFooterImages(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Image _buildJournalHeaderImage() => Image(
        image: AssetImage('assets/images/present.jpg'),
        fit: BoxFit.cover,
      );

  Column _buildJournalEntry() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Birthday',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          Text(
            'It\'s going to be a great birthday. We are going out for dinner at my favorite place, then watch a movie after we go to the gelateria for ice cream and espresso.',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      );

  Row _buildJournalWeather() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Icon(Icons.wb_sunny, color: Colors.orange)],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '81° Clear',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '4500 San Alpino Drive, Dallas, TX United States',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  Wrap _buildJournalTags() => Wrap(
        spacing: 8,
        children: List.generate(7, (index) {
          return Chip(
            label: Text(
              'Gift ${index + 1}',
              style: TextStyle(fontSize: 10),
            ),
            avatar: Icon(
              Icons.card_giftcard,
              color: Colors.blue.shade300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: Colors.grey,
              ),
            ),
            backgroundColor: Colors.grey.shade100,
          );
        }),
      );

  Row _buildJournalFooterImages() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/salmon.jpg'),
            radius: 40,
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/asparagus.jpg'),
            radius: 40,
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/strawberries.jpg'),
            radius: 40,
          ),
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.cake),
                Icon(Icons.star_border),
                Icon(Icons.music_note),
              ],
            ),
          ),
        ],
      );
}

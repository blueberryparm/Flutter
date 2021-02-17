import 'package:flutter/material.dart';

class ImagesAndIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image(
          width: MediaQuery.of(context).size.width / 3,
          image: AssetImage(
            'assets/images/logo.png',
          ),
          fit: BoxFit.cover,
        ),
        Image.network(
          'https://flutter.io/images/catalog-widget-placeholder.png',
          width: MediaQuery.of(context).size.width / 3,
        ),
        Icon(
          Icons.brush,
          color: Colors.lightBlue,
          size: 48,
        ),
      ],
    );
  }
}

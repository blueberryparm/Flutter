import 'package:flutter_driver/driver_extension.dart'; // (1)
import '../lib/pages/selection_page.dart' as app;
import 'package:flutter/material.dart';

void main() {
  enableFlutterDriverExtension(); // (2)

  runApp(// (3)
      MaterialApp(
    home: app.SelectionPage(),
  ));
}

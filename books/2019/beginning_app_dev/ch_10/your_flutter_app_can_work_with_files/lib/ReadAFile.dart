import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'LayoutDrawer.dart';

class ReadAFile extends StatefulWidget {
  @override
  _ReadAFileState createState() => _ReadAFileState();
}

class _ReadAFileState extends State<ReadAFile> {
  String _filename = 'newFile.txt';
  String _text = 'No text yet';
  String _message = '';
  bool _errorStatus = false;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _filename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LayoutAppBar().toPreferredSizeWidget(context),
      drawer: LayoutDrawer(),
      body: _body,
    );
  }

  Widget get _body {
    final TextStyle _messageStyle = _errorStatus
        ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyText2;
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          Text('Reading from $_filename'),
          TextField(
            decoration: const InputDecoration(labelText: 'Filename'),
            controller: _controller,
            onChanged: (String value) {
              setState(() {
                _filename = value;
              });
            },
          ),
          RaisedButton(
            child: const Icon(Icons.open_in_browser),
            onPressed: () async {
              final Directory documents =
                  await getApplicationDocumentsDirectory();
              _errorStatus = false;
              final File file = File('${documents.path}/$_filename');
              try {
                final String text = await file.readAsString();
                setState(() {
                  _text = text;
                  _message = '$_filename has this text inside it: "$_text"';
                });
              } catch (e) {
                setState(() {
                  _errorStatus = true;
                  _message = 'Error: $e';
                });
              }
            },
          ),
          Text(
            _text,
            style: const TextStyle(fontFamily: 'Courier'),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Text(
              _message,
              style: _messageStyle,
            ),
          ),
        ],
      ),
    );
  }
}

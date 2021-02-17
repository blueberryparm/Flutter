import 'package:flutter/material.dart';

class InputDecoratorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Notes',
            labelStyle: TextStyle(color: Colors.purple),
            // border: UnderlineInputBorder(),
            // border: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.purple,
            //   ),
            // ),
            border: OutlineInputBorder(),
          ),
        ),
        Divider(
          height: 50,
          color: Colors.lightGreen,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter your notes',
          ),
        ),
      ],
    );
  }
}

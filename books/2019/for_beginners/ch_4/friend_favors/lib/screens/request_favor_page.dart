import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../models/friend.dart';

class RequestFavorPage extends StatelessWidget {
  final List<Friend> friends;

  RequestFavorPage({Key key, this.friends}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requesting a favor'),
        leading: CloseButton(),
        actions: [
          FlatButton(
            textColor: Colors.white,
            child: Text('SAVE'),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Request a favor to:'),
              DropdownButtonFormField(
                items: friends
                    .map(
                      (friend) => DropdownMenuItem(
                        child: Text(friend.name),
                      ),
                    )
                    .toList(),
              ),
              Container(
                height: 16.0,
              ),
              Text("Favor description:"),
              TextFormField(
                maxLines: 5,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
              ),
              Container(
                height: 16.0,
              ),
              Text("Due Date:"),
              DateTimeField(
                format: DateFormat("EEEE, MMMM, d, yyyy 'at' h:mmma"),
                decoration: InputDecoration(
                  labelText: 'Date/Time',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                onShowPicker: null,
                onChanged: (dt) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

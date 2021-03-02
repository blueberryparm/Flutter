// Show the user a dialog window that allows them to insert or edit a ShoppingList
import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/list_items.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();

    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }

    return AlertDialog(
      title: Text(isNew ? 'New Shopping Item' : 'Edit Shopping Item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: 'Shopping List Item'),
            ),
            TextField(
              controller: txtQuantity,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Quantity of Item'),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(hintText: 'Add Note for Item'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Save Item'),
              onPressed: () {
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;
                helper.insertItem(item);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

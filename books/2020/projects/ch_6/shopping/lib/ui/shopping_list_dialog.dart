// Show the user a dialog window that allows them to insert or edit a ShoppingList
import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DbHelper helper = DbHelper();

    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }

    return AlertDialog(
      title: Text(isNew ? 'New Shopping List' : 'Edit Shopping List'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: 'Shopping List Name'),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(hintText: 'Shopping List Priority (1-3)'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Save Shopping List'),
              onPressed: () {
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                helper.insertList(list);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/shopping_list.dart';
import '../models/list_items.dart';
import 'list_item_dialog.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  ItemsScreen(this.shoppingList);

  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  DbHelper helper;
  List<ListItem> items;
  ListItemDialog dialog;

  _ItemsScreenState(this.shoppingList);

  @override
  void initState() {
    dialog = ListItemDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(shoppingList.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: items != null ? items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            //Key(shoppingList[index].name),
            key: Key(items[index].name),
            child: ListTile(
              title: Text(items[index].name),
              subtitle: Text(
                'Quantity: ${items[index].quantity} - Note: ${items[index].note}',
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => dialog.buildDialog(
                      context,
                      items[index],
                      false,
                    ),
                  );
                },
              ),
            ),
            onDismissed: (direction) {
              String strName = items[index].name;
              helper.deleteItem(items[index]);
              setState(() => items.removeAt(index));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$strName deleted'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(
              context,
              ListItem(0, shoppingList.id, '', '', ''),
              true,
            ),
          );
        },
      ),
    );
  }

  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() => items = items);
  }
}

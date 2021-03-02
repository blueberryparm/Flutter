import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/shopping_list.dart';
import 'shopping_list_dialog.dart';
import 'items_screen.dart';

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList;
  ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: shoppingList != null ? shoppingList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(shoppingList[index].name),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(shoppingList[index].priority.toString()),
              ),
              title: Text(shoppingList[index].name),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext ctx) =>
                      dialog.buildDialog(ctx, shoppingList[index], false),
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemsScreen(
                    shoppingList[index],
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              String strName = shoppingList[index].name;
              helper.deleteList(shoppingList[index]);
              setState(() => shoppingList.removeAt(index));
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
              ShoppingList(0, '', 0),
              true,
            ),
          );
        },
      ),
    );
  }

  Future showData() async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(() => shoppingList = shoppingList);
    // ShoppingList list = ShoppingList(0, 'Bakery', 2);
    // int listId = await helper.insertList(list);
    // ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    // int itemId = await helper.insertItem(item);
    // print('List Id: ${listId.toString()}');
    // print('Item Id: ${itemId.toString()}');
  }
}
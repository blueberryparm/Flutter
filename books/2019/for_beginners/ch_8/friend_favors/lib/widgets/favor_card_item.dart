import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/favor.dart';
import '../pages/favors_page.dart';

class FavorCardItem extends StatelessWidget {
  final Favor favor;

  const FavorCardItem({Key key, this.favor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.headline5;

    return Card(
      key: ValueKey(favor.uuid),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            _itemHeader(favor),
            Hero(
              tag: "description_${favor.uuid}",
              child: Text(
                favor.description,
                style: bodyStyle,
              ),
            ),
            _itemFooter(context, favor)
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _itemHeader(Favor favor) {
    return Row(
      children: <Widget>[
        Hero(
          tag: "avatar_${favor.uuid}",
          child: CircleAvatar(
            backgroundImage: favor.friend.photoURL != null
                ? NetworkImage(
                    favor.friend.photoURL,
                  )
                : AssetImage('assets/images/default_avatar.png'),
          ),
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("${favor.friend.name} asked you to... ")),
        )
      ],
    );
  }

  Widget _itemFooter(BuildContext context, Favor favor) {
    if (favor.isCompleted) {
      final format = DateFormat();
      return Container(
        margin: EdgeInsets.only(top: 8.0),
        alignment: Alignment.centerRight,
        child: Chip(
          label: Text("Completed at: ${format.format(favor.completed)}"),
        ),
      );
    }
    if (favor.isRequested) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text("Refuse"),
            onPressed: () => FavorsPageState.of(context).refuseToDo(favor),
          ),
          FlatButton(
            child: Text("Do"),
            onPressed: () => FavorsPageState.of(context).acceptToDo(favor),
          )
        ],
      );
    }
    if (favor.isDoing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text("give up"),
            onPressed: () => FavorsPageState.of(context).giveUp(favor),
          ),
          FlatButton(
            child: Text("complete"),
            onPressed: () => FavorsPageState.of(context).complete(favor),
          )
        ],
      );
    }

    return Container();
  }
}

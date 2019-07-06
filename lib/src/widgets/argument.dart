import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Argument extends StatelessWidget {
  Argument({Key key, @required this.text, @required this.onDelete}) : super(key: key);
  final String text;
  final Function onDelete;

  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(child: ListTile(title: Text(text))),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: onDelete,
        ),
      ],
    );
  }
}

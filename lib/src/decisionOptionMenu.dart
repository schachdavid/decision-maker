import 'package:flutter/material.dart';

// This is the type used by the popup menu below.
enum MenuOptions { delete, edit }

// This menu button widget updates a _selection field (of type WhyFarther,
// not shown here).

class DecisionOptionMenu extends StatefulWidget {
  final Function edit;
  final Function delete;

  DecisionOptionMenu(this.delete, this.edit, {Key key}) : super(key: key);

  @override
  _DecisionOptionMenuState createState() => _DecisionOptionMenuState(edit, delete);
}

class _DecisionOptionMenuState extends State<DecisionOptionMenu> {
  final Function edit;
  final Function delete;
  var _selection;

  _DecisionOptionMenuState(this.edit, this.delete);


  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      onSelected: (MenuOptions result) {
        switch(result) {
          case MenuOptions.edit: this.edit(); break;
          case MenuOptions.delete: this.delete(); break;
        }
        setState(() {
          
          _selection = result;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.delete, 
              child: Text('Delete'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.edit,
              child: Text('Edit'),
            ),
           
          ],
    );
  }
}

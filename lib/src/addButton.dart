import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  AddButton({@required this.onPress});
  final Function onPress;

  Widget build(BuildContext context) {
    return Ink(
      child: IconButton(
        icon: Icon(Icons.add),
        color: Colors.white,
        onPressed: onPress,
      ),
    );
  }
}

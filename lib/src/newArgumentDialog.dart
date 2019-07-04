import 'package:decision_maker/src/plainObjects/argument.dart';
import 'package:flutter/material.dart';

class NewArgumentDialog extends StatelessWidget {
  NewArgumentDialog({@required this.addArgument,@required this.title, @required this.formKey});

  final Argument argument = Argument();
  final String title;
  final Function addArgument;
  final formKey;

  void _submitForm() {
    final FormState form = formKey.currentState;
    form.save();
    addArgument(argument);
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Argument'),
      content: new Form(
        key: this.formKey,
        child: new Container(
            height: 80.0,
            child: new Column(
              children: <Widget>[
                new TextFormField(
                    decoration: new InputDecoration(labelText: 'text'),
                    onSaved: (val) => argument.text = val),
              ],
            )),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text('CREATE'),
          onPressed: () {
            _submitForm();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

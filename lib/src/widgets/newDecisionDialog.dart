import 'package:decision_maker/src/plainObjects/decision.dart';
import 'package:flutter/material.dart';

class NewDecisionDialog extends StatelessWidget {
  NewDecisionDialog({@required this.addDecisionOption, @required this.formKey});

  final Decision newDecisionOption = new Decision();
  final addDecisionOption;
  final formKey;

  void _submitForm() {
    final FormState form = formKey.currentState;
    newDecisionOption.proArgs = [];
    newDecisionOption.conArgs = [];
    form.save();
    addDecisionOption(newDecisionOption);
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Option'),
      content: new Form(
          key: this.formKey,
          child: new Container(
            height: 130.0,
            child: new Column(
              children: <Widget>[
                new TextFormField(
                    decoration: new InputDecoration(labelText: 'Title'),
                    onSaved: (val) => newDecisionOption.title = val),
                new TextFormField(
                    decoration: new InputDecoration(labelText: 'Notes'),
                    onSaved: (val) => newDecisionOption.notes = val),
              ],
            ),
          )),
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

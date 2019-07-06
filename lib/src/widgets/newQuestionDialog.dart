import 'package:decision_maker/src/plainObjects/decision.dart';
import 'package:decision_maker/src/plainObjects/question.dart';
import 'package:flutter/material.dart';

class NewQuestionDialog extends StatelessWidget {
  NewQuestionDialog({@required this.addQuestion, @required this.formKey});

  final Question newQuestion = new Question();
  final addQuestion;
  final formKey;

  void _submitForm() {
    final FormState form = formKey.currentState;
    form.save();
    addQuestion(newQuestion);
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Question'),
      content: new Form(
          key: this.formKey,
          child: new Container(
            height: 70.0,
            child: new Column(
              children: <Widget>[
                new TextFormField(
                    decoration: new InputDecoration(labelText: 'Text'),
                    onSaved: (val) => newQuestion.text = val),
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

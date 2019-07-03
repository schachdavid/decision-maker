import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'plainObjects/decision.dart';
import 'DecisionOption.dart';
import 'newOptionDialog.dart';

var uuid = new Uuid();

class QuestionDetails extends StatelessWidget {
  QuestionDetails({@required this.decisions});

  final List<Decision> decisions;
 
  Decision newDecisionOption;

  final String decisionPersistentKey = 'decisions';

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  void _updateDecisions(List<Decision> newDecisions) {
    // setState(() {
    //   decisions = newDecisions;
    // });
    // persistDecisions();
  }

  updateDecision(Decision decision) {
    // List<Decision> newDecisions = new List.from(decisions);
    // newDecisions[decision.id] = decision;
    // _updateDecisions(newDecisions);
  }

  persistDecisions() async {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // sp.setString(decisionPersistentKey, jsonEncode(decisions.values.toList()));
  }

  loadPersistentDecisions() async {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // List<Decision> newDecisions = new List<Decision>();
    // jsonDecode(sp.getString(decisionPersistentKey)).forEach((map) {
    //   Decision decision = new Decision.fromJson(map);
    //   newDecisions[decision.key] = decision;
    // });
    // _updateDecisions(newDecisions);
  }

  int calcScore(Decision decision) {
    // int proArgsLength = proArgs != null ? proArgs.length : 0;
    // int conArgsLength = conArgs != null ? conArgs.length : 0;
    // return proArgsLength - conArgsLength;
  }

  void addDecisionOption(Decision newDecision) {
    // List<Decision> newDecisions = new List.from(decisions);
    // newDecisions.add(newDecision);
    // _updateDecisions(newDecisions);
  }

  deleteOption(Decision decisionToDelete) {
    // List<Decision> newDecisions = new List.from(decisions);
    // newDecisions.remove(decisionToDelete.key);
    // newDecisions.forEach((k, v) => print(k + ": " + v.title));
    // _updateDecisions(newDecisions);
    // newDecisions.forEach((k, v) => print(k + ": " + v.title));
  }

  _displayDialog(BuildContext context) async {
    // newDecisionOption = new Decision();
    // return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return NewOptionDialog(
    //           newDecisionOption: newDecisionOption,
    //           addDecisionOption: addDecisionOption,
    //           formKey: formKey);
    //     });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    List<Decision> sortedDecisions = List.from(decisions);
    sortedDecisions.sort((a, b) => calcScore(a).compareTo(calcScore(b)));
    sortedDecisions = sortedDecisions.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the QuestionDetails object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("random title"),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(bottom: 80.0),
        child: Column(
          children: sortedDecisions
              .map<Widget>((Decision decision) => DecisionOption(
                  key: ObjectKey(decision),
                  decision: decision,
                  updateDecision: updateDecision,
                  deleteDecision: deleteOption))
              .toList(),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

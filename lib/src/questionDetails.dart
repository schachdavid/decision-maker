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


class QuestionDetails extends StatefulWidget {
  QuestionDetails({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _QuestionDetailsState createState() => _QuestionDetailsState();
}

class _QuestionDetailsState extends State<QuestionDetails> {
  HashMap<String, Decision> decisions = new HashMap<String, Decision>();

  Decision newDecisionOption;

  final String decisionPersistentKey = 'decisions';

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  void _updateDecisions(HashMap<String, Decision> newDecisions) {
    setState(() {
      decisions = newDecisions;
    });
    persistDecisions();
  }

  updateDecision(Decision decision) {
    HashMap<String, Decision> newDecisions = new HashMap.from(decisions);
    newDecisions[decision.key] = decision;
    _updateDecisions(newDecisions);
  }

  persistDecisions() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(decisionPersistentKey, jsonEncode(decisions.values.toList()));
  }

  loadPersistentDecisions() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    HashMap<String, Decision> newDecisions = new HashMap<String, Decision>();
    jsonDecode(sp.getString(decisionPersistentKey)).forEach((map) {
      Decision decision = new Decision.fromJson(map);
      newDecisions[decision.key] = decision;
    });
    _updateDecisions(newDecisions);
  }

  int calcScore(Decision decision) {
    int proArgsLength = decision.proArgs != null ? decision.proArgs.length : 0;
    int conArgsLength = decision.conArgs != null ? decision.conArgs.length : 0;
    return proArgsLength - conArgsLength;
  }

  void addDecisionOption(Decision newDecision) {
    HashMap<String, Decision> newDecisions = new HashMap.from(decisions);
    newDecision.key = uuid.v1();
    newDecisions[newDecision.key] = newDecision;
    _updateDecisions(newDecisions);
  }

  deleteOption(Decision decisionToDelete) {
    HashMap<String, Decision> newDecisions = new HashMap.from(decisions);
    print(decisionToDelete.key);
    newDecisions.remove(decisionToDelete.key);
    newDecisions.forEach((k, v) => print(k + ": " + v.title));
    _updateDecisions(newDecisions);
    newDecisions.forEach((k, v) => print(k + ": " + v.title));
  }

  _displayDialog(BuildContext context) async {
    newDecisionOption = new Decision();
    return showDialog(
        context: context,
        builder: (context) {
          return NewOptionDialog(
              newDecisionOption: newDecisionOption,
              addDecisionOption: addDecisionOption,
              formKey: formKey);
        });
  }

  initState() {
    super.initState();
    loadPersistentDecisions();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    List<Decision> sortedDecisions = decisions.values.toList();
    sortedDecisions.sort((a, b) => calcScore(a).compareTo(calcScore(b)));
    sortedDecisions = sortedDecisions.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the QuestionDetails object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 80.0),
        child: Column(
          children: sortedDecisions
              .map<Widget>((decision) => DecisionOption(
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
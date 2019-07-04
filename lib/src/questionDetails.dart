import 'dart:convert';
import 'dart:collection';

import 'package:decision_maker/src/state/decisionsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
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

  int calcScore(Decision decision) {
    int proArgsLength = decision.proArgs != null ? decision.proArgs.length : 0;
    int conArgsLength = decision.conArgs != null ? decision.conArgs.length : 0;
    return proArgsLength - conArgsLength;
  }

  _displayDialog(BuildContext context, Function addDecision) async {
    newDecisionOption = new Decision();
    return showDialog(
        context: context,
        builder: (context) {
          return NewOptionDialog(
              newDecisionOption: newDecisionOption,
              addDecisionOption: addDecision,
              formKey: formKey);
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Decision> sortedDecisions = List.from(decisions);
    sortedDecisions.sort((a, b) => calcScore(a).compareTo(calcScore(b)));
    sortedDecisions = sortedDecisions.reversed.toList();
    return Scaffold(
      appBar: AppBar(
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
                  deleteDecision: Provider.of<DecisionsState>(context).deleteDecision))
              .toList(),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context, Provider.of<DecisionsState>(context).addDecision),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

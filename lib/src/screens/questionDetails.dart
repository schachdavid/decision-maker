import 'package:decision_maker/src/plainObjects/decision.dart';
import 'package:decision_maker/src/state/decisionsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:decision_maker/src/widgets/DecisionOption.dart';
import 'package:decision_maker/src/widgets/newDecisionDialog.dart';

var uuid = new Uuid();

class QuestionDetails extends StatelessWidget {
  QuestionDetails({@required this.decisions, @required this.title});

  final List<Decision> decisions;

  final String title;

  final GlobalKey<FormState> newDecisionFormKey = new GlobalKey<FormState>();

  int calcScore(Decision decision) {
    int proArgsLength = decision.proArgs != null ? decision.proArgs.length : 0;
    int conArgsLength = decision.conArgs != null ? decision.conArgs.length : 0;
    return proArgsLength - conArgsLength;
  }

  _displayDialog(BuildContext context, Function addDecision) async {
    return showDialog(
        context: context,
        builder: (context) {
          return NewDecisionDialog(
              addDecisionOption: addDecision,
              formKey: newDecisionFormKey);
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Decision> sortedDecisions = List.from(decisions);
    sortedDecisions.sort((a, b) => calcScore(a).compareTo(calcScore(b)));
    sortedDecisions = sortedDecisions.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(bottom: 80.0),
        child: Column(
          children: sortedDecisions
              .map<Widget>((Decision decision) => DecisionOption(
                  key: ObjectKey(decision),
                  decision: decision,
                  deleteDecision: Provider.of<DecisionsState>(context).deleteDecision))
              .toList(),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context, Provider.of<DecisionsState>(context).addDecision),
        child: Icon(Icons.add),
      ),
    );
  }
}

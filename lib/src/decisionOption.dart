import 'package:flutter/material.dart';

import 'addButton.dart';
import 'decisionOptionMenu.dart';
import 'plainObjects/decision.dart';

class DecisionOption extends StatelessWidget {
  DecisionOption({@required this.decision, @required this.updateDecision, @required this.deleteDecision});

  final Decision decision;
  final Function updateDecision;
  final Function deleteDecision;

  addProArg(String argument) {
    Decision newDecision = new Decision(title: decision.title, proArgs: decision.proArgs, conArgs: decision.conArgs, notes: decision.notes, key: decision.key);
    newDecision.proArgs.add(argument);
    updateDecision(newDecision);
  }

  addConArg(String argument) {
    Decision newDecision = new Decision(title: decision.title, proArgs: decision.proArgs, conArgs: decision.conArgs, notes: decision.notes, key: decision.key);
    newDecision.conArgs.add(argument);
    updateDecision(newDecision);
  }

  @override
  Widget build(BuildContext context) {
    String notes = decision.notes;
    List<String> proArgs = decision.proArgs;
    List<String> conArgs = decision.conArgs;
    String text = decision.title;

    String score = (proArgs.length - conArgs.length).toString();

    var pointsTextStyle = TextStyle(
        fontSize: 32.0,
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.w600);

    var subTitle = decision.notes != null ? Text(notes) : null;

    List<Widget> proArgsWidgets = proArgs != null
        ? proArgs.map<Widget>((arg) => ListTile(title: Text(arg))).toList()
        : [];

    List<Widget> conArgsWidgets = conArgs != null
        ? conArgs.map<Widget>((arg) => ListTile(title: Text(arg))).toList()
        : [];

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text(score, style: pointsTextStyle),
                title: Text(text),
                subtitle: subTitle,
                trailing: DecisionOptionMenu(() => print("editing"),() => print("deleting")),
              ),
              Container(
                  color: Colors.teal[500],
                  child: ListTile(
                    title: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                          Text('Pro'),
                         AddButton(onPress: () => addProArg("hello")),
                        ])),
                  )),
              Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: proArgsWidgets)),
              Container(
                  color: Colors.red[500],
                  child: ListTile(
                    title: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                          Text('Con'),
                          AddButton(onPress: () => addConArg("hello")),
                        ])),
                  )),
              Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: conArgsWidgets)),
            ],
          ),
        ),
      ),
    );
  }
}

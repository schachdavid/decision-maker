import 'package:flutter/material.dart';

import 'addButton.dart';
import 'decisionOptionMenu.dart';
import 'plainObjects/decision.dart';
import 'newArgumentDialog.dart';
import 'argument.dart';

class DecisionOption extends StatelessWidget {
  DecisionOption(
      {Key key,
      @required this.decision,
      @required this.updateDecision,
      @required this.deleteDecision})
      : super(key: key);

  final Decision decision;
  final Function updateDecision;
  final Function deleteDecision;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  _displayDialog(BuildContext context, Function onAdd, String title) async {
    return showDialog(
        context: context,
        builder: (context) {
          return NewArgumentDialog(addArgument: onAdd, formKey: formKey, title: title);
        });
  }

  addProArg(String argument) {
    Decision newDecision = new Decision(
        title: decision.title,
        proArgs: decision.proArgs,
        conArgs: decision.conArgs,
        notes: decision.notes,
        key: decision.key);
    newDecision.proArgs.add(argument);
    updateDecision(newDecision);
  }

  addConArg(String argument) {
    Decision newDecision = new Decision(
        title: decision.title,
        proArgs: decision.proArgs,
        conArgs: decision.conArgs,
        notes: decision.notes,
        key: decision.key);
    newDecision.conArgs.add(argument);
    updateDecision(newDecision);
  }

  deleteConArgument(int index) {
    Decision newDecision = new Decision(
        title: decision.title,
        proArgs: decision.proArgs,
        conArgs: decision.conArgs,
        notes: decision.notes,
        key: decision.key);
    newDecision.conArgs.removeAt(index);
    updateDecision(newDecision);
  }

  deleteProArgument(int index) {
    Decision newDecision = new Decision(
        title: decision.title,
        proArgs: decision.proArgs,
        conArgs: decision.conArgs,
        notes: decision.notes,
        key: decision.key);
    newDecision.proArgs.removeAt(index);
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

    List<Widget> proArgsWidgets = new List<Widget>();
    for(var i = 0; i < proArgs.length; i++){
        proArgsWidgets.add(new Argument(key: ObjectKey(proArgs[i]),text: proArgs[i], onDelete: () => deleteProArgument(i),));
    }


    List<Widget> conArgsWidgets = new List<Widget>();
    for(var i = 0; i < conArgs.length; i++){
        conArgsWidgets.add(new Argument(key: ObjectKey(conArgs[i]),text: conArgs[i], onDelete: () => deleteConArgument(i),));
    }
    


    // List<Widget> proArgsWidgets = proArgs != null
    //     ? proArgs.map<Widget>((arg) => Argument(key: ObjectKey(arg))).toList()
    //     : [];

    // List<Widget> conArgsWidgets = conArgs != null
    //     ? conArgs.map<Widget>((arg) => Argument(text: arg)).toList()
    //     : [];

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
        elevation: 0,
        margin: EdgeInsets.only(top: 8.0),

        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text(score, style: pointsTextStyle),
                title: Text(text),
                subtitle: subTitle,
                trailing: DecisionOptionMenu(
                    () => this.deleteDecision(decision),
                    () => print("editing")),
              ),
              Container(
                  color: Colors.teal[500],
                  child: ListTile(
                    title: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                          Text('Pro'),
                          AddButton(
                              onPress: () =>
                                  _displayDialog(context, addProArg, "Pro Argument")),
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
                          AddButton(
                              onPress: () =>
                                  _displayDialog(context, addConArg, "Con Argument")),
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

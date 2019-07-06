import 'package:decision_maker/src/plainObjects/conArgument.dart';
import 'package:decision_maker/src/plainObjects/decision.dart';
import 'package:decision_maker/src/plainObjects/proArgument.dart';
import 'package:decision_maker/src/state/decisionsState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:decision_maker/src/widgets/addButton.dart';
import 'package:decision_maker/src/widgets/decisionOptionMenu.dart';
import 'package:decision_maker/src/widgets/newArgumentDialog.dart';
import 'package:decision_maker/src/widgets/argument.dart';

class DecisionOption extends StatelessWidget {
  DecisionOption(
      {Key key,
      @required this.decision,
      @required this.deleteDecision})
      : super(key: key);

  final Decision decision;
  final Function deleteDecision;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  _displayDialog(BuildContext context, Function onAdd, String title) async {
    return showDialog(
        context: context,
        builder: (context) {
          return NewArgumentDialog(
              addArgument: onAdd, formKey: formKey, title: title);
        });
  } 

  @override
  Widget build(BuildContext context) {
    String notes = decision.notes;
    List<ProArgument> proArgs = decision.proArgs;
    List<ConArgument> conArgs = decision.conArgs;
    String text = decision.title;

    String score = (proArgs.length - conArgs.length).toString();

    var pointsTextStyle = TextStyle(
        fontSize: 32.0,
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.w600);
    var subTitle = decision.notes != null ? Text(notes) : null;

    List<Widget> proArgsWidgets = new List<Widget>();
    Function deleteProArg = Provider.of<DecisionsState>(context)
        .deleteProArgForDecisionFactory(decision);
    for (var i = 0; i < proArgs.length; i++) {
      proArgsWidgets.add(new Argument(
          key: ObjectKey(proArgs[i]),
          text: proArgs[i].text,
          onDelete: () => deleteProArg(proArgs[i])));
    }

    List<Widget> conArgsWidgets = new List<Widget>();
     Function deleteConArg = Provider.of<DecisionsState>(context)
        .deleteConArgForDecisionFactory(decision);
    for (var i = 0; i < conArgs.length; i++) {
      conArgsWidgets.add(new Argument(
        key: ObjectKey(conArgs[i]),
        text: conArgs[i].text,
        onDelete: () => deleteConArg(conArgs[i]),
      ));
    }

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
                              onPress: () => _displayDialog(
                                  context,
                                  Provider.of<DecisionsState>(context)
                                      .addProArgForDecisionFactory(decision),
                                  "Pro Argument")),
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
                              onPress: () => _displayDialog(
                                  context,
                                  Provider.of<DecisionsState>(context)
                                      .addConArgForDecisionFactory(decision),
                                  "Con Argument")),
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

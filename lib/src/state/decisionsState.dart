import 'dart:collection';

import 'package:decision_maker/src/database/db.dart';
import 'package:decision_maker/src/plainObjects/argument.dart';
import 'package:decision_maker/src/plainObjects/conArgument.dart';
import 'package:decision_maker/src/plainObjects/decision.dart';
import 'package:decision_maker/src/plainObjects/proArgument.dart';
import 'package:flutter/material.dart';

class DecisionsState extends ChangeNotifier {
  DecisionsState() {
    getDecisionsWithArgs();
  }

  final List<Decision> _decisions = [];

  void getDecisionsWithArgs() async {
    List<Decision> newDecisions = await DBProvider.db.getAllDecisions();

    //get args for decisions from db
    for (Decision decision in newDecisions) {
      decision.proArgs =
          await DBProvider.db.getProArgumentsForDecision(decision.id);

      decision.conArgs =
          await DBProvider.db.getConArgumentsForDecision(decision.id);
    }

    _decisions.clear();
    _decisions.addAll(newDecisions);
    notifyListeners();
  }

  addDecision(Decision decision) async {
    var res = await DBProvider.db.newDecision(decision);
    decision.id = res;
    _decisions.add(decision);
    notifyListeners();
  }

  deleteDecision(Decision decision) {
    DBProvider.db.deleteDecision(decision.id);
    for (int i = 0; i < decisions.length; i++) {
      if (decisions[i].id == decision.id) {
        _decisions.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  ///returns a function which adds proargs for the specific decision
  Function addProArgForDecisionFactory(Decision decision) {
    return (Argument arg) {
      ProArgument proArg =
          ProArgument(id: arg.id, text: arg.text, decisionId: decision.id);
      DBProvider.db.newProArgument(proArg);
      for (int i = 0; i < decisions.length; i++) {
        if (decisions[i].id == decision.id) {
          _decisions[i].proArgs.add(proArg);
          break;
        }
      }
    };
  }

  Function addConArgForDecisionFactory(Decision decision) {
    return (Argument arg) {
      ConArgument conArg =
          ConArgument(id: arg.id, text: arg.text, decisionId: decision.id);
      DBProvider.db.newConArgument(conArg);
      for (int i = 0; i < decisions.length; i++) {
        if (decisions[i].id == decision.id) {
          _decisions[i].conArgs.add(conArg);
          break;
        }
      }
    };
  }

  

  addConArgForDecision(ConArgument arg, Decision decision) {
    arg.decisionId = decision.id;
    DBProvider.db.newConArgument(arg);
    for (int i = 0; i < decisions.length; i++) {
      if (decisions[i].id == decision.id) {
        _decisions[i].conArgs.add(arg);
      }
    }
  }

  UnmodifiableListView<Decision> get decisions =>
      UnmodifiableListView(_decisions);
}

import 'dart:collection';

import 'package:decision_maker/src/database/db.dart';
import 'package:decision_maker/src/plainObjects/argument.dart';
import 'package:decision_maker/src/plainObjects/conArgument.dart';
import 'package:decision_maker/src/plainObjects/decision.dart';
import 'package:decision_maker/src/plainObjects/proArgument.dart';
import 'package:flutter/material.dart';

class DecisionsState extends ChangeNotifier {
  DecisionsState({@required this.questionId}) {
    getDecisionsWithArgs();
  }

  final int questionId;
  final List<Decision> _decisions = [];

  void getDecisionsWithArgs() async {
    List<Decision> newDecisions = await DBProvider.db.getDecisionsForQuestion(this.questionId);

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
    decision.questionId = questionId;
    var res = await DBProvider.db.newDecision(decision);
    decision.id = res;
    _decisions.add(decision);
    notifyListeners();
  }

  int _getDecisionIndexByIdFromState(Decision decision) {
    for (int i = 0; i < _decisions.length; i++) {
      if (_decisions[i].id == decision.id) {
        return i;
      }
    }
    return -1;
  }

  int _getArgIndexById(List<Argument> args, Argument arg) {
    for (int i = 0; i < args.length; i++) {
      if (args[i].id == arg.id) {
        return i;
      }
    }
    return -1;
  }

  deleteDecision(Decision decision) {
    //delete in database
    DBProvider.db.deleteDecision(decision.id);
    //delete in state
    int decisionIndex = _getDecisionIndexByIdFromState(decision);
    _decisions.removeAt(decisionIndex);
    notifyListeners();
  }

  ///returns a function which adds proArgs for the specific decision
  Function addProArgForDecisionFactory(Decision decision) {
    return (Argument arg) async {
      ProArgument proArg = ProArgument(text: arg.text, decisionId: decision.id);
      var id = await DBProvider.db.newProArgument(proArg);
      proArg.id = id;
      int decisionIndex = _getDecisionIndexByIdFromState(decision);
      _decisions[decisionIndex].proArgs.add(proArg);
    };
  }

  deleteProArgForDecisionFactory(Decision decision) {
    return (ProArgument proArg) {
      DBProvider.db.deleteProArgument(proArg.id);
      int decisionIndex = _getDecisionIndexByIdFromState(decision);
      List<ProArgument> args = _decisions[decisionIndex].proArgs;
      int argIndex = _getArgIndexById(args, proArg);
      args.removeAt(argIndex);
      notifyListeners();
    };
  }

  ///returns a function which adds conArgs for the specific decision
  Function addConArgForDecisionFactory(Decision decision) {
    return (Argument arg) async {
      ConArgument conArg =
          ConArgument(id: arg.id, text: arg.text, decisionId: decision.id);
      var id = await DBProvider.db.newConArgument(conArg);
      conArg.id = id;
      int decisionIndex = _getDecisionIndexByIdFromState(decision);
      _decisions[decisionIndex].conArgs.add(conArg);
    };
  }

  deleteConArgForDecisionFactory(Decision decision) {
    return (ConArgument conArg) {
      DBProvider.db.deleteConArgument(conArg.id);
      int decisionIndex = _getDecisionIndexByIdFromState(decision);
      List<ConArgument> args = _decisions[decisionIndex].conArgs;
      int argIndex = _getArgIndexById(args, conArg);
      args.removeAt(argIndex);
      notifyListeners();
    };
  }

  UnmodifiableListView<Decision> get decisions =>
      UnmodifiableListView(_decisions);
}

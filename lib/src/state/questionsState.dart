import 'dart:collection';

import 'package:decision_maker/src/plainObjects/question.dart';
import 'package:decision_maker/src/database/db.dart';
import 'package:flutter/material.dart';

class QuestionsState extends ChangeNotifier {
  QuestionsState() {
    getQuestions();
  }

  final List<Question> _questions = [];

  void getQuestions() async {
    List<Question> newQuestions = await DBProvider.db.getAllQuestions();
    _questions.clear();
    _questions.addAll(newQuestions);
    notifyListeners();
  }

  addQuestion(Question question) async {
    var res = await DBProvider.db.newQuestion(question);
    question.id = res;
    _questions.add(question);
    notifyListeners();
  }

  deleteDecision(Question question) {
    //delete in database
    DBProvider.db.deleteQuestion(question.id);
    //delete in state
    int decisionIndex = _getQuestionIndexByIdFromState(question);
    _questions.removeAt(decisionIndex);
    notifyListeners();
  }

  UnmodifiableListView<Question> get questions =>
      UnmodifiableListView(_questions);

  int _getQuestionIndexByIdFromState(Question question) {
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].id == question.id) {
        return i;
      }
    }
    return -1;
  }
}

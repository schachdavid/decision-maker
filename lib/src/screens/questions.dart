import 'package:decision_maker/src/plainObjects/question.dart';
import 'package:decision_maker/src/screens/questionDetails.dart';
import 'package:decision_maker/src/state/decisionsState.dart';
import 'package:decision_maker/src/state/questionsState.dart';
import 'package:decision_maker/src/widgets/newQuestionDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Questions extends StatelessWidget {
  Questions({@required this.questions});

  final List<Question> questions;

  final GlobalKey<FormState> newQuestionFormKey = new GlobalKey<FormState>();

 _displayDialog(BuildContext context, Function addQuestion) async {
    return showDialog(
        context: context,
        builder: (context) {
          return NewQuestionDialog(
              addQuestion: addQuestion,
              formKey: newQuestionFormKey);
        });
  }
  _onItemTap(BuildContext context, Question question) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                builder: (context) => DecisionsState(questionId: question.id),
                child: Consumer<DecisionsState>(
                    builder: (context, decisionsState, child) {
                  return QuestionDetails(
                      decisions: decisionsState.decisions,
                      title: question.text);
                }))));
  }

  Widget build(BuildContext context) {
    List<ListTile> questionTiles = questions
        .map((question) => ListTile(
              title: Text(question.text),
              onTap: () => _onItemTap(context, question),
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions"),
      ),
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(bottom: 80.0),
              child: Column(
                children: questionTiles,
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context, Provider.of<QuestionsState>(context).addQuestion),
        child: Icon(Icons.add),
      ),
    );
  }
}

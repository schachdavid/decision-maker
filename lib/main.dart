import 'package:decision_maker/src/plainObjects/question.dart';
import 'package:decision_maker/src/screens/questionDetails.dart';
import 'package:decision_maker/src/screens/questionDetails.dart';
import 'package:decision_maker/src/screens/questions.dart';
import 'package:decision_maker/src/state/questionsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import 'package:decision_maker/src/state/decisionsState.dart';
import 'package:decision_maker/src/database/db.dart';
import 'package:decision_maker/src/plainObjects/decision.dart';

var uuid = new Uuid();

void main() {
  runApp(MyApp());
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  List<Decision> decisions = new List<Decision>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Open Sans',
        brightness: Brightness.dark,
      ),
      home: QuestionsOverwiew(title: 'Decisionmaker'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) =>
            QuestionsOverwiew(title: 'Decisionmaker'),
        // '/detail': (BuildContext context) =>
        //     new QuestionDetails(decisions: decisions),
      },
    );
  }
}

class QuestionsOverwiew extends StatefulWidget {
  QuestionsOverwiew({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _QuestionsOverwiewState createState() => _QuestionsOverwiewState();
}

class _QuestionsOverwiewState extends State<QuestionsOverwiew> {
  _displayDialog(BuildContext context) {}

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (context) => QuestionsState(),
        child:
            Consumer<QuestionsState>(builder: (context, questionsState, child) {
          return Questions(questions: questionsState.questions);
        }));
  }
}

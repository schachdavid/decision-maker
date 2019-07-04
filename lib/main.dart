import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import 'package:decision_maker/src/state/decisionsState.dart';
import 'package:decision_maker/src/database/db.dart';
import 'package:decision_maker/src/plainObjects/decision.dart';
import 'package:decision_maker/src/plainObjects/proArgument.dart';
import 'package:decision_maker/src/plainObjects/conArgument.dart';

import 'src/questionDetails.dart';

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
  _displayDialog(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                builder: (context) => DecisionsState(),
                child: Consumer<DecisionsState>(
                    builder: (context, decisionsState, child) {
                  return QuestionDetails(decisions: decisionsState.decisions);
                }))));
  }

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (context) => DecisionsState(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.only(bottom: 80.0),
            child: Column(),
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _displayDialog(context),
            child: Icon(Icons.add),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'src/database/db.dart';
import 'src/database/models/DecisionModel.dart';
import 'src/database/models/ProArgumentModel.dart';
import 'src/questionDetails.dart';

var uuid = new Uuid();

void main() {
  runApp(MyApp());
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        '/detail': (BuildContext context) =>
            QuestionDetails(title: 'Decisionmaker'),
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
  _displayDialog(BuildContext context) async {
    await DBProvider.db.clean();
    // Navigator.pushNamed(context, '/detail');
    Decision newDecision =
        new Decision(title: "Some random option.", notes: "some note");
    var res = await DBProvider.db.newDecision(newDecision);
    DBProvider.db.getAllDecisions().then((decisions) {
      decisions.forEach((decision) => print(decision));
    });

    ProArgument newProArg =
        new ProArgument(text: "Some Pro Arg.", decisionId: res);
    await DBProvider.db.newProArgument(newProArg);
    print("Response: $res");
    DBProvider.db.getAllProArguments().then((proArgs) {
      proArgs.forEach((proArg) => print(proArg));
    });
  }

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

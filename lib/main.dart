import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'src/database/db.dart';
import 'src/database/models/DecisionModel.dart' as Model;
import 'src/plainObjects/decision.dart';
import 'src/database/models/ProArgumentModel.dart';
import 'src/database/models/ConArgumentModel.dart';

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
  _displayDialog(BuildContext context) async {
    await DBProvider.db.clean();
    Model.Decision newDecision =
        new Model.Decision(title: "Some random option.", notes: "some note");
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

    List<Model.Decision> decisions = await DBProvider.db.getAllDecisions();
    List<Decision> decisionsWithArgs = await Future.wait(decisions.map((decision) async {
      List<ProArgument> proArgs = await DBProvider.db.getProArgumentsForDecision(decision.id);
      List<ConArgument> conArgs = await DBProvider.db.getConArgumentsForDecision(decision.id);
      return new Decision(
          title: decision.title,
          notes: decision.notes,
          proArgs: proArgs.map((arg) => arg.text).toList(),
          conArgs: conArgs.map((arg) => arg.text).toList());
    }).toList());
    

    
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              new QuestionDetails(decisions: decisionsWithArgs),
        ));
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
        child: Icon(Icons.add),
      ),
    );
  }
}

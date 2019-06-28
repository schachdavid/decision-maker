import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'src/plainObjects/decision.dart';
import 'src/DecisionOption.dart';
import 'src/newOptionDialog.dart';

var uuid = new Uuid();

void main() => runApp(MyApp());

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
      home: MyHomePage(title: 'Worüber soll ich meine BA schreiben?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HashMap<String, Decision> decisions = new HashMap<String, Decision>();

  Decision newDecisionOption;

  final String decisionPersistentKey = 'decisions';

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  void _updateDecisions(HashMap<String, Decision> newDecisions) {
    setState(() {
      decisions = newDecisions;
    });
    persistDecisions();
  }

  updateDecision(Decision decision) {
    HashMap<String, Decision> newDecisions = new HashMap.from(decisions);
    newDecisions[decision.key] = decision;
    _updateDecisions(newDecisions);
  }

  persistDecisions() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(decisionPersistentKey, jsonEncode(decisions.values.toList()));
  }

  loadPersistentDecisions() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    HashMap<String, Decision> newDecisions = new HashMap<String, Decision>();
    jsonDecode(sp.getString(decisionPersistentKey)).forEach((map) {
      Decision decision = new Decision.fromJson(map);
      newDecisions[decision.key] = decision;
    });
    _updateDecisions(newDecisions);
  }

  int calcScore(Decision decision) {
    int proArgsLength = decision.proArgs != null ? decision.proArgs.length : 0;
    int conArgsLength = decision.conArgs != null ? decision.conArgs.length : 0;
    return proArgsLength - conArgsLength;
  }

  void addDecisionOption(Decision newDecision) {
    HashMap<String, Decision> newDecisions = new HashMap.from(decisions);
    newDecision.key = uuid.v1();
    newDecisions[newDecision.key] = newDecision;
    _updateDecisions(newDecisions);
  }

  deleteOption(Decision decisionToDelete) {
    HashMap<String, Decision> newDecisions = new HashMap.from(decisions);
    newDecisions.remove(decisionToDelete.key);
    _updateDecisions(newDecisions);
  }

  _displayDialog(BuildContext context) async {
    newDecisionOption = new Decision();
    return showDialog(
        context: context,
        builder: (context) {
          return NewOptionDialog(
              newDecisionOption: newDecisionOption,
              addDecisionOption: addDecisionOption,

              formKey: formKey);
        });
  }

  initState() {
    super.initState();
    loadPersistentDecisions();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    List<Decision> sortedDecisions = decisions.values.toList();
    sortedDecisions.sort((a, b) => calcScore(a).compareTo(calcScore(b)));
    sortedDecisions = sortedDecisions.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: sortedDecisions
              .map<Widget>((decision) => DecisionOption(
                  decision: decision, updateDecision: updateDecision, deleteDecision: () => print("deleting"),))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

import './models/DecisionDAO.dart';
import './models/ProArgumentDAO.dart';
import './models/ConArgumentDAO.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "decision_maker3.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("PRAGMA foreign_keys = ON;");
      await db.execute("CREATE TABLE decision ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "notes TEXT"
          ")");
      await db.execute("CREATE TABLE pro_argument ("
          "id INTEGER PRIMARY KEY,"
          "text TEXT,"
          "decision_id INTEGER,"
          "FOREIGN KEY (decision_id) REFERENCES decision(id)"
          ")");
      await db.execute("CREATE TABLE con_argument ("
          "id INTEGER PRIMARY KEY,"
          "text TEXT,"
          "decision_id INTEGER,"
          "FOREIGN KEY (decision_id) REFERENCES decision(id)"
          ")");
    });
  }

  ///delete the whole database
  clean() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "decision_maker.db");
    deleteDatabase(path);
    path = join(documentsDirectory.path, "decision_maker2.db");
    deleteDatabase(path);
    path = join(documentsDirectory.path, "decision_maker3.db");
    deleteDatabase(path);
  }

  newDecision(Decision newDecision) async {
    final db = await database;
    var tmp = await db.rawQuery("SELECT * FROM decision");
    print(tmp);

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM decision");
    int id = table.first["id"];
    newDecision.id = id;
    var res = await db.insert("decision", newDecision.toMap());
    return res;
  }

  getDecision(int id) async {
    final db = await database;
    var res =await  db.query("Decision", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Decision.fromMap(res.first) : Null ;
  }

  Future<List<Decision>> getAllDecisions() async {
    final db = await database;
    var res = await db.query("decision");
    List<Decision> list =
        res.isNotEmpty ? res.map((c) => Decision.fromMap(c)).toList() : [];
    return list;
  }

  newProArgument(ProArgument newProArgument) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM pro_argument");
    int id = table.first["id"];
    newProArgument.id = id;
    var res = await db.insert("pro_argument", newProArgument.toMap());
    return res;
  }

  Future<List<ProArgument>> getAllProArguments() async {
    final db = await database;
    var res = await db.query("pro_argument");
    List<ProArgument> list =
        res.isNotEmpty ? res.map((c) => ProArgument.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<ProArgument>> getProArgumentsForDecision(int decisionId) async {
    final db = await database;
    var res = await db.query("pro_argument",
        where: "decision_id = ?", whereArgs: [decisionId]);
    List<ProArgument> list =
        res.isNotEmpty ? res.map((c) => ProArgument.fromMap(c)).toList() : [];
    return list;
  }

  newConArgument(ConArgument newConArgument) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM con_argument");
    int id = table.first["id"];
    newConArgument.id = id;
    var res = await db.insert("con_argument", newConArgument.toMap());
    return res;
  }

  Future<List<ConArgument>> getAllConArguments() async {
    final db = await database;
    var res = await db.query("con_argument");
    List<ConArgument> list =
        res.isNotEmpty ? res.map((c) => ConArgument.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<ConArgument>> getConArgumentsForDecision(int decisionId) async {
    final db = await database;
    var res = await db.query("con_argument",
        where: "decision_id = ?", whereArgs: [decisionId]);
    List<ConArgument> list =
        res.isNotEmpty ? res.map((c) => ConArgument.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> getScore(int decisionId) async {
    final db = await database;
    var res_pro_args = await db.query("pro_argument",
        where: "decision_id = ?", whereArgs: [decisionId]);
    var res_con_args = await db.query("con_argument",
        where: "decision_id = ?", whereArgs: [decisionId]);
    return res_pro_args.length - res_con_args.length;
  }
}

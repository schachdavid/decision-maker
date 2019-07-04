import 'package:decision_maker/src/database/dao/ConArgumentDAO.dart';
import 'package:decision_maker/src/database/dao/DecisionDao.dart';
import 'package:decision_maker/src/database/dao/ProArgumentDao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../plainObjects/conArgument.dart';
import '../plainObjects/decision.dart';
import '../plainObjects/proArgument.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static final DecisionDao _decisionDao = DecisionDao();
  static final ProArgumentDao _proArgumentDao = ProArgumentDao();
  static final ConArgumentDao _conArgumentDao = ConArgumentDao();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "decision_maker6.db");
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
          "FOREIGN KEY (decision_id) REFERENCES decision(id) ON DELETE CASCADE"
          ")");
      await db.execute("CREATE TABLE con_argument ("
          "id INTEGER PRIMARY KEY,"
          "text TEXT,"
          "decision_id INTEGER,"
          "FOREIGN KEY (decision_id) REFERENCES decision(id) ON DELETE CASCADE"
          ")");
    });
  }

  ///delete the whole database
  clean() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "decision_maker.db");
    await deleteDatabase(path);
    path = join(documentsDirectory.path, "decision_maker2.db");
    await deleteDatabase(path);
    path = join(documentsDirectory.path, "decision_maker3.db");
    await deleteDatabase(path);
  }

  newDecision(Decision newDecision) async {
    final db = await database;

    var tmp = await db.rawQuery("SELECT * FROM decision");
    print(tmp);

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM decision");
    int id = table.first["id"];
    newDecision.id = id;
    var res = await db.insert("decision", _decisionDao.toMap(newDecision));
    return res;
  }

  getDecision(int id) async {
    final db = await database;
    var res = await db.query("Decision", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? _decisionDao.fromMap(res.first) : Null;
  }

  deleteDecision(int id) async {
    final db = await database;
    await db.execute("PRAGMA foreign_keys = ON;");
    var res = await db.delete("decision", where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<List<Decision>> getAllDecisions() async {
    final db = await database;
    var res = await db.query("decision");
    List<Decision> list =
        res.isNotEmpty ? res.map((c) => _decisionDao.fromMap(c)).toList() : [];
    return list;
  }

  newProArgument(ProArgument newProArgument) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM pro_argument");
    int id = table.first["id"];
    newProArgument.id = id;
    var res =
        await db.insert("pro_argument", _proArgumentDao.toMap(newProArgument));
    return res;
  }

  Future<List<ProArgument>> getAllProArguments() async {
    final db = await database;
    var res = await db.query("pro_argument");
    List<ProArgument> list = res.isNotEmpty
        ? res.map((c) => _proArgumentDao.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<ProArgument>> getProArgumentsForDecision(int decisionId) async {
    final db = await database;
    var res = await db.query("pro_argument",
        where: "decision_id = ?", whereArgs: [decisionId]);
    List<ProArgument> list = res.isNotEmpty
        ? res.map((c) => _proArgumentDao.fromMap(c)).toList()
        : [];
    return list;
  }

  newConArgument(ConArgument newConArgument) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM con_argument");
    int id = table.first["id"];
    newConArgument.id = id;
    var res =
        await db.insert("con_argument", _conArgumentDao.toMap(newConArgument));
    return res;
  }

  Future<List<ConArgument>> getAllConArguments() async {
    final db = await database;
    var res = await db.query("con_argument");
    List<ConArgument> list = res.isNotEmpty
        ? res.map((c) => _conArgumentDao.fromMap(c)).toList()
        : [];
    return list;
  }

   deleteConArgument(int id) async {
    final db = await database;
    await db.execute("PRAGMA foreign_keys = ON;");
    var res = await db.delete("con_argument", where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<List<ConArgument>> getConArgumentsForDecision(int decisionId) async {
    final db = await database;
    var res = await db.query("con_argument",
        where: "decision_id = ?", whereArgs: [decisionId]);
    List<ConArgument> list = res.isNotEmpty
        ? res.map((c) => _conArgumentDao.fromMap(c)).toList()
        : [];
    return list;
  }
}

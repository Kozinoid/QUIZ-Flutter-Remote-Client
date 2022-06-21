import 'dart:io';
import 'package:quiflutter/model/data_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  // Fields
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  // Consts
  final String dbFilename = 'teamList.db';

  // Database getter
  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDB();
    }
    return _database;
  }

  // Init Database
  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '$dbFilename';
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  // Table consts
  final String tableName = 'TeamList';
  final String idColumn = 'id';
  final String nameColumn = 'name';
  final String scoreColumn = 'score';

  // Create Table
  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $scoreColumn INTEGER)');
  }

  // Get Table
  Future<List<OneTeam>> getTeamList() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> mapList = await db.query(tableName);
    final List<OneTeam> teamList = [];
    mapList.forEach((mapElement) {
      teamList.add(OneTeam.fromMap(mapElement));
      OneTeam team = OneTeam.fromMap(mapElement);
    });
    return teamList;
  }

  // INSERT
  Future<OneTeam> insertNewTeam(OneTeam team) async {
    Database db = await this.database;
    await db.insert(tableName, team.toMap());
    return team;
  }

  // CLEAR ALL
  Future<void> clearAll() async {
    Database db = await this.database;
    db.delete(tableName);
  }

  // STORE ALL DATABASE
  Future<void> storeAllDatabase(List<OneTeam> teamList) async {
    await clearAll();
    teamList.forEach((team) {
      insertNewTeam(team);
    });
  }

// // UPDATE
  // Future<int> updateTeam(OneTeam team) async {
  //   Database db = await this.database;
  //   return await db.update(
  //     tableName,
  //     team.toMap(),
  //     where: '$idColumn = ?',
  //     whereArgs: [team.teamID]
  //   );
  // }
  //
  // // DELETE
  // Future<int> deleteTeam(int id) async {
  //   Database db = await this.database;
  //   return db.delete(
  //       tableName,
  //       where: '$idColumn = ?',
  //       whereArgs: [id]
  //   );
  // }

  // // DELETE DATABASE
  // Future<void> deleteDB() async {
  //   Directory dir = await getApplicationDocumentsDirectory();
  //   String path = dir.path + '$dbFilename';
  //   await deleteDatabase(path);
  // }
  //
  // // Get Team count
  // Future<int> getTeamCount() async {
  //   Database db = await this.database;
  //   return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  // }
}

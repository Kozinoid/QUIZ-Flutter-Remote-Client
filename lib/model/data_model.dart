import 'package:flutter/material.dart';
import 'package:quiflutter/connection/net_connection.dart';
import 'package:quiflutter/database/team_db.dart';

//--------------------------  All teams data model  ----------------------------
class DataModel extends ChangeNotifier {

  List<OneTeam> _teamList = [];         // Team list
  int get length => _teamList.length;   // Team count
  int _min = 0;                         // Max Team Score
  int _max = 0;                         // Min Team Score
  final NetConnection connection;       // Connection

  DataModel({this.connection});

  // Get Team
  OneTeam getTeam(int index) => _teamList[index];

  // Connection changed


  // Add New Team
  bool addNewTeam({String name = 'New Team'}) {
    if (!hasName(name)) {
      _teamList.add(OneTeam(name: name));
      _refreshIndexes();
      _refreshAll();

      // Send Add team
      connection.sendAddTeamCommand(name, 0);

      return true;
    } else {
      return false;
    }
  }

  // Team list has Name?
  bool hasName(String name){
    bool res = false;
    _teamList.forEach((team) {
      if (team.teamName == name) res = true;
    });
    return res;
  }

  // Remove Team
  void removeTeam(int index) {
    String name = _teamList[index].teamName;

    _teamList.removeAt(index);
    _refreshIndexes();
    _refreshAll();

    // Send remove team
    connection.sendDeleteTeamCommand(name);
  }

  // Rename Team
  void renameTeam(int index, String newName) {
    String name = _teamList[index].teamName;

    _teamList[index].teamName = newName;
    _refreshAll();

    // Send rename command
    connection.sendRenameTeamCommand(name, newName);
  }

  // Set Team Score
  void setTeamScore(int index, int newScore) {
    String name = _teamList[index].teamName;

    _teamList[index].teamScore = newScore;
    _refreshAll();

    // Send refresh team command
    connection.sendRefreshTeamCommand(name, newScore);
  }

  // Increment Team Score
  void incrementTeamScore(int index) {
    _teamList[index].incrementScore();

    String name = _teamList[index].teamName;
    int newScore = _teamList[index].teamScore;

    _refreshAll();

    // Send refresh team command
    connection.sendRefreshTeamCommand(name, newScore);
  }

  // Decrement Team Score
  void decrementTeamScore(int index) {
    _teamList[index].decrementScore();

    String name = _teamList[index].teamName;
    int newScore = _teamList[index].teamScore;

    _refreshAll();

    // Send refresh team command
    connection.sendRefreshTeamCommand(name, newScore);
  }

  void sendRefreshAllTable(){
    // Send table
    connection.sendClearTableCommand();
    for (int index = 0; index < _teamList.length; index++){
      connection.sendAddTeamCommand(_teamList[index].teamName, _teamList[index].teamScore);
    }
  }

  // Sort By Score
  void sortByScores() {
    _teamList.sort((teamA, teamB) => teamB.teamScore - teamA.teamScore);
    _refreshIndexes();
    _refreshAll();

    // Send refresh All table
    sendRefreshAllTable();
  }

  // Refresh all
  void _refreshAll() {
    _findMinMax();
    notifyListeners();
  }

  // Find Min/Max
  void _findMinMax() {
    if (_teamList.length == 0) return;
    _min = _teamList[0].teamScore;
    _max = _teamList[0].teamScore;
    _teamList.forEach((team) {
      if (team.teamScore > _max) _max = team.teamScore;
      if (team.teamScore < _min) _min = team.teamScore;
    });
  }

  // Refresh Indexes
  void _refreshIndexes(){
    for (var i = 0; i < _teamList.length; i++){
      _teamList[i].teamId = i + 1;
    }
  }

  // Is [index] Team has Max/Mid/Min score? - <1; 0; -1>
  int isMaxMin(int index) {
    if (_teamList[index].teamScore == _max) return 1;
    if (_teamList[index].teamScore == _min) return -1;
    return 0;
  }

  // Clear Team List
  void clearAll(){
    _teamList.clear();
    _refreshAll();

    // Send clear table
    connection.sendClearTableCommand();
  }

  //---------------------------  DATA STORE  -----------------------------------
  // Store all data
  void loadData() async {
     _teamList.clear();
     _teamList = await DBProvider.db.getTeamList();
     _refreshAll();
  }

  // Restore all data
  void saveData() async {
    _refreshIndexes();
    await DBProvider.db.storeAllDatabase(_teamList);
  }
}

// ------------------------  One team data class  ------------------------------
class OneTeam {
  // Constructor
  OneTeam({String name}) {
    this.teamName = name;
  }

  // Properties
  int teamId = 0;
  String teamName = ''; // Team name
  int teamScore = 0; // Team score

  // ToMap
  Map<String, dynamic> toMap(){
    return {
      'id': teamId,
      'name': teamName,
      'score': teamScore
    };
  }

  // FromMap
  OneTeam.fromMap(Map<String, dynamic> teamMap){
    teamId = teamMap['id'];
    teamName = teamMap['name'];
    teamScore = teamMap['score'];
  }

  // Inc Score
  void incrementScore() {
    teamScore++;
  }

  // Dec Score
  void decrementScore() {
    if (teamScore > 0) teamScore--;
  }
}

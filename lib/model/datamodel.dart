import 'package:flutter/material.dart';
import 'package:quiflutter/database/teamdb.dart';

//--------------------------  All teams data model  ----------------------------
class DataModel extends ChangeNotifier {
  // Team list
  List<OneTeam> _teamList = [];

  // Team count
  int get length => _teamList.length;

  // Max Team Score
  int _min = 0;

  // Min Team Score
  int _max = 0;

  // Get Team
  OneTeam getTeam(int index) {
    return _teamList[index];
  }

  // Add New Team
  bool addNewTeam({String name = 'New Team'}) {
    if (!hasName(name)) {
      _teamList.add(OneTeam(name: name));
      refreshIndexes();
      refreshAll();
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
    _teamList.removeAt(index);
    refreshIndexes();
    refreshAll();
  }

  // Rename Team
  void renameTeam(int index, String newName) {
    _teamList[index].teamName = newName;
    refreshAll();
  }

  // Set Team Score
  void setTeamScore(int index, int newScore) {
    _teamList[index].teamScore = newScore;
    refreshAll();
  }

  // Increment Team Score
  void incrementTeamScore(int index) {
    _teamList[index].incrementScore();
    refreshAll();
  }

  // Decrement Team Score
  void decrementTeamScore(int index) {
    _teamList[index].decrementScore();
    refreshAll();
  }

  // Sort By Score
  void sortByScores() {
    _teamList.sort((teamA, teamB) => teamB.teamScore - teamA.teamScore);
    refreshIndexes();
    refreshAll();
  }

  // Refresh all
  void refreshAll() {
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
  void refreshIndexes(){
    for (var i = 0; i < _teamList.length; i++){
      _teamList[i].teamID = i + 1;
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
    refreshAll();
  }

  //---------------------------  DATA STORE  -----------------------------------
  // Store all data
  void loadData() async {
     _teamList.clear();
     _teamList = await DBProvider.db.getTeamList();
     refreshAll();
  }

  // Restore all data
  void saveData() async {
    refreshIndexes();
    await DBProvider.db.storeAllDatabase(_teamList);
  }
}

// ------------------------  One team data class  ------------------------------
class OneTeam {
  // Constructor
  OneTeam({String name}) {
    this._teamName = name;
  }

  // Fields
  int _teamId = null;
  String _teamName = ''; // Team name
  int _teamScore = 0; // Team score

  // Setters/Getters
  set teamID(int id) => _teamId = id;
  get teamID => _teamId;
  set teamName(String newName) => _teamName = newName;
  get teamName => _teamName;
  set teamScore(int newScore) => _teamScore = newScore;
  get teamScore => _teamScore;

  // ToMap
  Map<String, dynamic> toMap(){
    return {
      'id': _teamId,
      'name': _teamName,
      'score': _teamScore
    };
  }

  // FromMAp
  OneTeam.fromMap(Map<String, dynamic> teamMap){
    _teamId = teamMap['id'];
    _teamName = teamMap['name'];
    _teamScore = teamMap['score'];
  }

  // Inc Score
  void incrementScore() {
    _teamScore++;
  }

  // Dec Score
  void decrementScore() {
    _teamScore--;
  }
}

import 'package:flutter/material.dart';

//--------------------------  All teams data model  ----------------------------
class DataModel extends ChangeNotifier {
  // Team list
  List<OneTeam> _teamList = [
    OneTeam(name: "Andrew"),
    OneTeam(name: "Sergey"),
    OneTeam(name: "Irina"),
    OneTeam(name: "Vasya"),
    OneTeam(name: "Tolya"),
  ];

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

  // Is [index] Team has Max/Mid/Min score? - <1; 0; -1>
  int isMaxMin(int index) {
    if (_teamList[index].teamScore == _max) return 1;
    if (_teamList[index].teamScore == _min) return -1;
    return 0;
  }
}

// ------------------------  One team data class  ------------------------------
class OneTeam {
  // Constructor
  OneTeam({String name}) {
    this._teamName = name;
  }

  // Fields
  String _teamName = ''; // Team name
  int _teamScore = 0; // Team score

  // Setters/Getters
  set teamName(String newName) => _teamName = newName;

  String get teamName => _teamName;

  set teamScore(int newScore) => _teamScore = newScore;

  int get teamScore => _teamScore;

  // Inc Score
  void incrementScore() {
    _teamScore++;
  }

  // Dec Score
  void decrementScore() {
    _teamScore--;
  }
}

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiflutter/connection/tcp_client.dart';
import 'package:quiflutter/connection/connection_constants.dart';
import 'package:quiflutter/connection/udp_client.dart';

import 'app_constants.dart';

class NetConnection with ChangeNotifier{
  final UdpClient udpClient = UdpClient(ConnectionConstants.UDP_SEARCH_IP, ConnectionConstants.UDP_SEARCH_PORT);
  final TcpClient tcpClient = TcpClient(ConnectionConstants.APP_PORT);

  StreamController<bool> _streamController = StreamController<bool>();
  StreamController<bool> get streamController => _streamController;

  // Connection state
  bool _connected = false;
  bool get connected => _connected;

  // Constructor
  NetConnection(){
    // Connection callback
    tcpClient.onConnectionChange = _changeConnectionState;
  }

  // Connect
  void connect() async {
    String serverIp = await udpClient.searchServerIp();
    tcpClient.connect(serverIp);
  }

  // Disconnect
  void disconnect(){

    tcpClient.disconnect();
    //_streamController.close();
  }

  // Tcp connection changed
  void _changeConnectionState(bool connectionState){
    _connected = connectionState;
    _streamController.add(_connected);
    notifyListeners();
  }

  //---------------------------  COMMANDS  -------------------------------------
  // Universal command
  void sendMessage(String message){
    if (connected) tcpClient.sendMessage(message);
  }
  // Fullscreen command
  void sendFullscreenModeCommand(){
    sendMessage(AppConstants.FULLSCREEN_MODE + '/');
  }
  // Clear table command
  void sendClearTableCommand(){
    sendMessage(AppConstants.NEW_TABLE + '/');
  }
  // Add team command
  void sendAddTeamCommand(String name, int score){
    String command = AppConstants.ADD_NEW_TEAM + '<' + name + '>' + score.toString() + '#/';
    sendMessage(command);
  }
  // Delete team command
  void sendDeleteTeamCommand(String name){
    String command = AppConstants.DELETE_TEAM + '<' + name + '>#/';
    sendMessage(command);
  }
  // Refresh team command
  void sendRefreshTeamCommand(String name, int score){
    String command = AppConstants.REFRESH_TEAM_RECORD + '<' + name + '>' + score.toString() + '#/';
    sendMessage(command);
  }

  // Rename team command
  void sendRenameTeamCommand(String name, String newName){
    String command = AppConstants.REFRESH_TEAM_RECORD + '<' + name + '><' + newName + '>#/';
    sendMessage(command);
  }
}
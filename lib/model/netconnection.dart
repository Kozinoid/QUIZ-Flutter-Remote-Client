import 'package:flutter/cupertino.dart';
import 'package:quiflutter/model/tcpconnection.dart';
import 'package:quiflutter/model/udpconnection.dart';

class NetConnection with ChangeNotifier{
  TcpConnection _tcp;
  UdpConnection _udp;
  String serverIP;
  bool connected = false;

  NetConnection(){
    _tcp = TcpConnection(onReceive: _tcpReceive);
    _udp = UdpConnection(onReceive: _udpReceive);
  }

  //---------------------  SEARCH ID  ---------------------------
  void searchIP(){
    print('connecting udp...');
    _udp.connect();
  }
  //---------------------  UDP RECEIVE  -------------------------
  void _udpReceive(){
    print('Response: ${_udp.response}');
    if (_udp.response == '#Q#U#I#Z'){
      serverIP = _udp.serverIP;
      _udp.disconnect();
      _tcpConnect();
    }
  }
  //---------------------  TCP CONNECT  -------------------------
  void _tcpConnect(){
    print('connecting TCP');
    _tcp.connect(serverIP, '#n#e#w');
  }
  //---------------------  TCP RECEIVE  -------------------------
  void _tcpReceive(){
    print('Response: ${_tcp.serverResponse}');
    if (_tcp.serverResponse == '#y#e#s'){
      print('connection - true');
      connected = true;
      notifyListeners();
    }
  }
  //----------------------  DISCONNECT  -------------------------
  void disconnect(){
    _tcp.disconnect();
    connected = false;
    notifyListeners();
  }

  //-------------------------------------------------------------
  //-------------------  COMMANDS  ------------------------------

  //---------------------------  One team score  -------------------------------
  void sendOneTeam(String name, int score)
  {
    String message = "#r#e#f<" + name + ">" + score.toString() + "#";
    if (connected) _tcp.sendTextMessage(message);
  }

  //---------------------------  Rename team  ----------------------------------
  void sendRenameTeam(String name, String newName)
  {
    String message = "#r#e#n<" + name + "><" + newName + ">#";
    if (connected) _tcp.sendTextMessage(message);
  }

  //--------------------------  Add new team  ----------------------------------
  void sendAddTeam(String name, int score)
  {
    String message = "#a#d#d<" + name + ">" + score.toString() + "#";
    if (connected) _tcp.sendTextMessage(message);
  }

  //---------------------------  Delete team  ----------------------------------
  void sendDeleteTeam(String name)
  {
    String message = "#d#e#l<" + name + ">#";
    if (connected) _tcp.sendTextMessage(message);
  }

  //------------------------  Send table  --------------------------------------
  void sendClearTable()
  {
    String message = "#t#a#b";
    if (connected) _tcp.sendTextMessage(message);
  }

  //-----------------------  Fullscreen mode  ----------------------------------
  void sendFullScreen()
  {
    String message = "#f#s#m";
    if (connected) _tcp.sendTextMessage(message);
  }
}

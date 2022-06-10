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
    //_udp.connect();
    _tcp.connect('192.168.0.106', '#n#e#w');
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
    _tcp.connect(serverIP, '#n#e#w');
  }
  //---------------------  TCP RECEIVE  -------------------------
  void _tcpReceive(){
    print('Response: ${_tcp.serverResponse}');
    if (_tcp.serverResponse == '#y#e#s'){
      connected = true;
      notifyListeners();
    }
  }
}

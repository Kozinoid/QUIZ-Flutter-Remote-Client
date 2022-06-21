import 'dart:typed_data';
import 'dart:io';
import 'package:quiflutter/connection/connection_constants.dart';

//---------------------------- TcpClient class ---------------------------------
class TcpClient {
  final int appPort;
  String hostIP;
  Socket socket;
  void Function(bool connectionState) onConnectionChange;

  // Connection state
  bool _connected = false;
  bool get connected => _connected;
  // Set connection state
  void _setConnection(bool state){
    _connected = state;
    onConnectionChange?.call(state);
  }

  // Constructor
  TcpClient(this.appPort);

  // Connect
  void connect(ip) async {
    hostIP = ip;
    try{
      socket = await Socket.connect(hostIP, appPort);
      sendMessage(ConnectionConstants.NEW_CLIENT_REQUEST);
      socket.listen((event){messageReceived(event);});
      print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      _setConnection(true);
    }
    catch(exception){
      print('${exception.toString()}');
      disconnect();
    }
  }

  // Send message
  void sendMessage(String message) {
    print('Send: $message');
    socket.write(message);
  }

  // Receive message
  void messageReceived(Uint8List event){
    String message = String.fromCharCodes(event, 0, event.length);
    if (message == ConnectionConstants.DISCONNECT) _closeAll();
    else{
      print('Received: $message');
      // ToDo Process messages here
    }
  }

  // Disconnect
  void disconnect(){
    sendMessage(ConnectionConstants.DISCONNECT);
    _closeAll();
  }

  // Close
  void _closeAll(){
    _setConnection(false);
    print('disconnecting...');
    socket.destroy();
  }
}
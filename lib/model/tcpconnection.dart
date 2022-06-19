import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'constants.dart';

class TcpConnection {
  TcpConnection({this.onReceive});

  void Function() onReceive;

  var _serverResponse = 'Ready';
  String get serverResponse => _serverResponse;
  var hostIP = DEFAAULT_IP;
  final appPort = APPLICATION_PORT;
  var socket;
  StreamSubscription<Uint8List> stream;

  //------------------------  CONNECT  --------------------------------
  void connect(String address, String connectionCommand) async {
    hostIP = address;

    try {
      socket = await Socket.connect(hostIP, appPort);
      print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      // listen for responses from the server
      stream = socket.listen(
        // handle data from the server
            (Uint8List data) {
          final response = new String.fromCharCodes(data);
          _onMessageReceived(response);
        },

        // handle errors
        onError: (error) {
          print(error.toString());
          disconnect();
        },
      );
    }catch(e){
      disconnect();
    }
    _sendMessage(socket, connectionCommand);
  }

//-----------------------  DISCONNECT  ------------------------------
  void disconnect(){
    _sendMessage(socket, '#e#n#d');
    print('disconnection');
    stream.cancel();
    socket.close();
    socket.destroy();
  }

  //------------------------  SEND MESSAGE  ---------------------------
  Future<void> _sendMessage(Socket socket, String message) async {
    print('Client: $message');
    socket.write(message);
    await Future.delayed(Duration(milliseconds: 1000));
  }
//------------------------  RECEIVE MESSAGE  ------------------------
  void _onMessageReceived(String response) {
    _serverResponse = response;
    print('Server: $_serverResponse');
    onReceive();
  }

  void sendTextMessage(String text){
    _sendMessage(socket, text);
  }
}
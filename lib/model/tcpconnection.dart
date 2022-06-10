import 'dart:typed_data';
import 'dart:io';
import 'package:quiflutter/model/udpconnection.dart';

import 'constants.dart';

class TcpConnection {
  TcpConnection({this.onReceive});

  void Function() onReceive;

  UdpConnection udpConnection = UdpConnection();
  var _serverResponse = 'Ready';
  String get serverResponse => _serverResponse;
  var hostIP = DEFAAULT_IP;
  final appPort = APPLICATION_PORT;

  void _singleTransaction(String message) async {
    try {
      // connect to the socket server
      final socket = await Socket.connect(hostIP, appPort);

      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      // send some messages to the server
      await _sendMessage(socket, message);

      // listen for responses from the server
      socket.listen(
        // handle data from the server
        (Uint8List data) {
          final response = new String.fromCharCodes(data);
          _onMessageReceived(response);
        },

        // handle errors
        onError: (error) {
          print(error.toString());
          //print('Connection error!');
          socket.destroy();
        },

        // handle server ending connection
        onDone: () {
          print('Server left.');
          socket.destroy();
        },
      );
    } catch (error) {
      print(error.toString());
    }
  }
//------------------------  SEND MESSAGE  ---------------------------
  Future<void> _sendMessage(Socket socket, String message) async {
    print('Client: $message');
    socket.write(message);
    await Future.delayed(Duration(milliseconds: 100));
  }
//------------------------  RECEIVE MESSAGE  ------------------------
  void _onMessageReceived(String response) {
    _serverResponse = response;
    print('Server: $_serverResponse');
    onReceive();
  }
//------------------------  CONNECT  --------------------------------
  void connect(String address, String connectionCommand){
    hostIP = address;
    print('hostIP: $hostIP');
    _singleTransaction(connectionCommand);
  }
}

import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ConnectionModel with ChangeNotifier{
  String _serverRespose = 'Ready';
  String get serverResponse => _serverRespose;

  void singleTransaction(String message) async {
    try{
      // connect to the socket server
      final socket = await Socket.connect('192.168.0.106', 8060);
      print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      // send some messages to the server
      await sendMessage(socket, message);

      // listen for responses from the server
      socket.listen(

        // handle data from the server
            (Uint8List data){
          final response = new String.fromCharCodes(data);
          onMessageReceived(response);
        },

        // handle errors
        onError: (error) {
          print(error.toString());
          socket.destroy();
        },

        // handle server ending connection
        onDone: () {
          print('Server left.');
          socket.destroy();
        },
      );
    }
    catch(error){
      print(error.toString());
    }
  }

  Future<void> sendMessage(Socket socket, String message) async {
    print('Client: $message');
    socket.write(message);
    await Future.delayed(Duration(milliseconds: 100));
  }

  void onMessageReceived(String response){
    _serverRespose = response;
    print('Server: $_serverRespose');
    notifyListeners();
  }
}
import 'dart:io';

import 'constants.dart';

class UdpConnection {
  UdpConnection({this.onReceive});

  void Function() onReceive;

  final String udpIPAddressText = SEARCH_ADDRESS;
  final int udpPort = SEARCH_PORT;
  String response;
  String serverIP;
  RawDatagramSocket _udpReceivingSocket;

  //------------------------------  CONNECT ------------------------------------
  void connect() async {
    int port = udpPort;
    // listen forever & send response
    _udpReceivingSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    response = null;
    _bind(_udpReceivingSocket);
  }

  //----------------------------  DISCONNECT -----------------------------------
  void disconnect(){
    _udpReceivingSocket.close();
  }

  //---------------------------  Get connection  -------------------------------
  void _bind(RawDatagramSocket socket) {
    socket.joinMulticast(InternetAddress.tryParse(udpIPAddressText));
    socket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram dg = socket.receive();
        if (dg != null) {
          response = String.fromCharCodes(dg.data);
          serverIP = dg.address.address;
        }
        else{
          response =  '';
          serverIP = '';
        }
        onReceive();
      }
    });
  }
}

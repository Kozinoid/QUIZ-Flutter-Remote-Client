import 'dart:async';
import 'dart:io';

//---------------------------- UdpClient class ---------------------------------
class UdpClient {
  UdpClient(this.udpIPAddressText, this.udpPort);

  // Fields
  final String udpIPAddressText;
  final int udpPort;
  String response;
  String serverIP;
  RawDatagramSocket _udpReceivingSocket;
  // Create Future for search result
  Completer<String> _completer;

  //------------------------------  CONNECT ------------------------------------
  void _connect() async {
    int port = udpPort;
    try{
      // listen forever & send response
      _udpReceivingSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
      response = null;
      _bind(_udpReceivingSocket);
    }
    catch(error){
      _disconnect();
      _completer.completeError(error);
    }
  }

  //----------------------------  DISCONNECT -----------------------------------
  void _disconnect(){
    _udpReceivingSocket.close();
  }

  //---------------------------  Get connection  -------------------------------
  void _bind(RawDatagramSocket socket) {
    try{
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
          // Server is found
          _disconnect();
          _completer.complete(serverIP);
        }
      });
    }
    catch(error){
      _disconnect();
      _completer.completeError(error);
    }
  }

  //-------------------- Search for server and get its IP ----------------------
  Future<String> searchServerIp(){
    _completer = Completer<String>();
    _connect();
    return _completer.future;
  }
}

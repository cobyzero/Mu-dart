import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:mu_dart/common/network/socket_client.dart';

class SocketServer {
  final int port;
  final InternetAddress ipAddress;

  SocketServer({required this.port, required this.ipAddress});

  final connections = <Socket, SocketClient>{};

late Socket serverSocket;


  bool _isInitialized = false;

  get isInitialized => _isInitialized;

  bool _isListening = false;

  get isListening => _isListening;

  void initialize() {
    _isInitialized = true;
  }

  int send(SocketClient? socketClient, Uint8List? data, int start, int count) {
    if (socketClient == null) {
      throw Exception("Connection Null");
    }
    if (data == null) {
      throw Exception("Data Null");
    }

    var totalBytesSent = 0;
    var bytesRemaining = data.length;

    try {
      while (bytesRemaining > 0) {
        var bytesSent = socketClient.socket.send(data, ipAddress, port);
        if (bytesSent > 0) {
          log("Data enviada");
        }

        bytesRemaining -= bytesSent;
        totalBytesSent += bytesSent;
      }
    } catch (e) {
      removeConnection(socketClient, true);
    }

    return totalBytesSent;
  }

  void removeConnection(SocketClient socketClient, bool raiseEvent) {
    // ignore: collection_methods_unrelated_type
    if (connections.remove(socketClient.socket) != null && raiseEvent) {
      log("Removed connection");
    }
  }

        void listen()async
     {
         if (!isInitialized)
         {
             throw Exception( "Not Initialised Param");
         }


         if (isListening)
         {
             throw Exception("[SocketServer] Server Allready Listening. Action Terminated");
             
         }


         serverSocket = await  Socket.connect(ipAddress, port);
         try
         {
          serverSocket.setOption(SocketOption.tcpNoDelay, true);
           }
         catch ( e)
         {
           //  Logger.Error(e, "Listen");
         }
         serverSocket.setRawOption(RawSocketOption.fromInt(RawSocketOption.levelSocket, , value))
         serverSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.DontLinger, true);


         serverSocket.Bind(new IPEndPoint(ipAddress, port));



         serverSocket.Listen(10);
         isListening = true;


         serverSocket.BeginAccept(AcceptCallback, null);
         Logger.Info("[SocketServer]Started Listen ");
     }
}

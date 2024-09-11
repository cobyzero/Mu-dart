import 'dart:io';
import 'dart:typed_data';

import 'package:mu_dart/common/network/socket_server.dart';

class SocketClient {
  final SocketServer networkServer;
  final RawDatagramSocket socket;
  SocketClient({
    required this.networkServer,
    required this.socket,
  });

  int send(Uint8List? buffer) {
    if (buffer == null) throw Exception("buffer");
    return send2(buffer, 0, buffer.length);
  }

  int send2(Uint8List? buffer, int start, int count) {
    if (buffer == null) throw Exception("buffer");
    return networkServer.send(this, buffer, start, count);
  }
}

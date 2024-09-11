import 'dart:io';

import 'package:mu_dart/common/crypt/simple_modulus.dart';
import 'package:mu_dart/common/crypt/xor_32_modulus.dart';
import 'package:mu_dart/common/network/socket_server.dart';
import 'package:mu_dart/game/packet/op_codes.dart';
import 'package:mu_dart/game/service/map_service.dart';

class GameCore {
  final MapService mapService = MapService();
  late final SocketServer socketService;
  GameCore() {
    SimpleModulus.initCryptSite(true);
    Xor32Modulus.initKeys(true);
    OpCodes.init();
    socketService = SocketServer(
      port: 8080,
      ipAddress: InternetAddress("127.0.0.1"),
    );
    mapService.init();
  }
}

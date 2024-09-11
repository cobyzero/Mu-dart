import 'dart:typed_data';

import 'package:mu_dart/common/crypt/crypt_process.dart';
import 'package:mu_dart/common/model/guild.dart';
import 'package:mu_dart/common/model/party.dart';
import 'package:mu_dart/common/model/storage.dart';
import 'package:mu_dart/common/network/socket_client.dart';

class Player {
  SocketClient? networkClient;

  int? accountIndex;
  int? index;
  int? slot;

  int? levelUpPoints;
  int? race;
  int? experience;
  int? experienceNext;
  int? strength;
  int? agility;
  int? vitality;
  int? energy;
  int? command;
  int? money;

  int? ag;
  int? agMax;
  int? sd;
  int? sdMax;

  int? authority;

  int? fruitAddPoint = 0;

  int? fruitMaxAddPoint = 0;

  int? fruitMinusPoint = 0;

  int? fruitMaxMinusPoint = 0;

  int? playersKillCount;
  int? playerKillLevel;
  int? playerKillTime;
  bool? isBanned;
  Storage? inventory;
  Storage? warehouse;
  Party? party;
  Guild? guild;

  void send(Uint8List data) {
    final encryptData = CryptProcess.encryptAsServer(data, 0);
    if (encryptData != null) {
      networkClient!.send(encryptData);
    }
  }
}

import 'package:mu_dart/common/model/default_object.dart';
import 'package:mu_dart/common/model/item.dart';
import 'package:mu_dart/common/model/npc.dart';
import 'package:mu_dart/common/model/player.dart';

class Creature extends DefaultObject {
  @override
  void release() {}

  List<Player> visiblePlayers = [];
  List<Npc> visibleNpcs = [];
  List<Item> visibleItems = [];

  Map? map;

  String? name;
  int? level;
  int? mapIndex;
  int? mapDirection;
  int? mapPositionX;
  int? mapPositionY;
  int? life;
  int? lifeMax;
  int? mana;
  int? manaMax;
}

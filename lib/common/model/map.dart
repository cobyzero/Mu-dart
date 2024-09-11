import 'package:mu_dart/common/model/item.dart';
import 'package:mu_dart/common/model/npc.dart';
import 'package:mu_dart/common/model/player.dart';

class Map {
  int? mapIndex;

  final players = <Player>[];
  final npcs = <Npc>[];
  final items = <Item>[];

  void release() {
    try {
      for (int i = 0; i < npcs.length; i++) {
        npcs[i].release();
      }

      npcs.clear();
    } catch (ex) {
      //  Logger.Error("MapInstance: Dispose", ex);
    }
    try {
      for (int i = 0; i < items.length; i++) {
        items[i].release();
      }

      items.clear();
    } catch (ex) {
      // Logger.Error("MapInstance: Dispose", ex);
    }
  }
}

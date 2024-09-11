import 'dart:collection';

class OpCodes {
  static final Map<int, Type> recv = HashMap<int, Type>();
  static final Map<int, Type> recvF1 = HashMap<int, Type>();
  static final Map<int, Type> recvF3 = HashMap<int, Type>();

  static void init() {
    recvF1[0x01] = RpLogin;
    recvF1[0x02] = RpLogout;
    recvF1[0x03] = RpHackCheck;

    recvF3[0x00] = RpPlayersList;
    recvF3[0x01] = RpPlayerCreate;
    recvF3[0x02] = RpPlayerDelete;
    recvF3[0x03] = RpPlayerEnterWorld;
    recvF3[0x06] = RpLevelUpPointAdd;
    recvF3[0x12] = RpMoveDataLoadingOK;
    recvF3[0x30] = RpMoveDataLoadingOK;

    recv[0x00] = RpChatNormal;
    recv[0x01] = RpChatRecive;
    recv[0x02] = RpChatWisper;
    recv[0x03] = RpCheckMain;
    recv[0x0E] = RpClientLive;
    recv[0xDF] = RpMove;
    recv[0xD3] = RpWalk;
    recv[0xDC] = RpAttack;
    recv[0x18] = RpAction;
    recv[0x19] = RpMagicAttack;
    recv[0x1B] = RpMagicAttackCancel;
    recv[0x1C] = RpTeleport;
    recv[0xB0] = RpTargetTeleport;
    recv[0xD7] = RpBeattackRecive;
    recv[0x1E] = RpDurationMagicRecive;
    recv[0x22] = RpItemGet;
    recv[0x23] = RpItemThrow;
    recv[0x24] = RpItemMove;
    recv[0x26] = RpItemUse;
    recv[0x30] = RpTalk;
    recv[0x31] = RpCloseWindow;
    recv[0x32] = RpItemBuy;
    recv[0x33] = RpItemSell;
    recv[0x34] = RpDurationRepair;
    recv[0x36] = RpTradeRequest;
    recv[0x37] = RpTradeResponse;
    recv[0x3A] = RpTradeMoney;
    recv[0x3C] = RpTradeOkButton;
    recv[0x3D] = RpTradeCancelButton;
  }
}

class RpLogin {}

class RpLogout {}

class RpHackCheck {}

class RpPlayersList {}

class RpPlayerCreate {}

class RpPlayerDelete {}

class RpPlayerEnterWorld {}

class RpLevelUpPointAdd {}

class RpMoveDataLoadingOK {}

class RpChatNormal {}

class RpChatRecive {}

class RpChatWisper {}

class RpCheckMain {}

class RpClientLive {}

class RpMove {}

class RpWalk {}

class RpAttack {}

class RpAction {}

class RpMagicAttack {}

class RpMagicAttackCancel {}

class RpTeleport {}

class RpTargetTeleport {}

class RpBeattackRecive {}

class RpDurationMagicRecive {}

class RpItemGet {}

class RpItemThrow {}

class RpItemMove {}

class RpItemUse {}

class RpTalk {}

class RpCloseWindow {}

class RpItemBuy {}

class RpItemSell {}

class RpDurationRepair {}

class RpTradeRequest {}

class RpTradeResponse {}

class RpTradeMoney {}

class RpTradeOkButton {}

class RpTradeCancelButton {}

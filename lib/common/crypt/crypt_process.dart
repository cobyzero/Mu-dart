import 'dart:typed_data';

import 'package:mu_dart/common/crypt/simple_modulus.dart';

class CryptProcess {
  static List decodeC3C4(Uint8List src, Uint8List dest, int counter) {
    if (src[0] == 0xC3 || src[0] == 0xC4) {
      if (src[0] == 0xC3) {
        int size = src[1];
        Uint8List tempDest = Uint8List((((size - 2 / 11) * 8) + 2 - 1).toInt());
        //! REVISAR LENGHT POR SI FALLA
        int result = SimpleModulus.decrypt(tempDest, 1, src, 2, src.length - 2);
        Uint8List returnDest = Uint8List(result + 1);
        returnDest.addAll(tempDest);
        counter = tempDest[1];
        returnDest[0] = 0xC3;
        returnDest[1] = (result + 1);
        dest = returnDest;
      } else {
        int size = (src[1] * 256) + src[2];
        Uint8List tempDest = Uint8List((((size - 3 / 11) * 8) + 3 - 1).toInt());
        int result = SimpleModulus.decrypt(tempDest, 2, src, 3, src.length - 3);
        Uint8List returnDest = Uint8List(result + 2);
        returnDest.addAll(tempDest);
        counter = tempDest[1];
        returnDest[0] = 0xC4;
        returnDest[1] = ((result + 2 & ~0x00FF) >> 8);
        returnDest[2] = (result + 2 & ~0xFF00);
        // ReturnDest[1] = (byte)(Result + 2);
        dest = returnDest;
      }
      return [dest, counter];
    } else {
      return [];
    }
  }

  static List encodeC3C4(Uint8List src, int counter) {
    if (src[0] == 0xC3 || src[0] == 0xC4) {
      {
        Uint8List dest;
        if (src[0] == 0xC3) {
          int size = src.length;
          Uint8List tempDest =
              Uint8List((((size - 2 / 11) * 8) + 2 - 1).toInt());
          src[1] = counter;
          int result =
              SimpleModulus.encrypt(tempDest, 2, src, 1, src.length - 1);
          Uint8List returnDest = Uint8List(result + 2);
          returnDest.addAll(tempDest);
          returnDest[1] = (result + 2);
          returnDest[0] = 0xC3;

          dest = returnDest;
        } else {
          int size = (src[1] * 256) + src[2];
          Uint8List tempDest =
              Uint8List((((size - 3 / 11) * 8) + 3 - 1).toInt());

          src[2] = counter;
          int result =
              SimpleModulus.encrypt(tempDest, 3, src, 2, src.length - 2);
          Uint8List returnDest = Uint8List(result + 3);
          returnDest.addAll(tempDest);

          returnDest[0] = 0xC4;
          returnDest[1] = ((result + 2 & ~0x00FF) >> 8);
          returnDest[2] = (result + 2 & ~0xFF00);

          dest = returnDest;
        }
        return [dest, counter];
      }
    } else {
      return [];
    }
  }

  static Uint8List? encryptAsServer(Uint8List src, int counter) {
    if (src[0] == 0xC3 || src[0] == (0xC4)) {
      SimpleModulus.initCryptSite(true);
      final encode = encodeC3C4(src, counter);

      if (encode.isNotEmpty) {
        return encode[0];
      }

      return null;
    } else if (src[0] == (0xC1) || src[0] == (0xC2)) {
      counter = -1;

      return src;
    } else {
      counter = -1;
      return null;
    }
  }
}

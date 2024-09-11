import 'dart:typed_data';

class SimpleModulus {
  static List<int> decryptKeys = List.filled(12, 0);
  static List<int> encryptKeys = List.filled(12, 0);

  static final List<int> clientDecryptKeys = [
    73326,
    109989,
    98843,
    171058,
    18035,
    30340,
    24701,
    11141,
    62004,
    64409,
    35374,
    64599
  ];

  static final List<int> clientEncryptKeys = [
    128079,
    164742,
    70235,
    106898,
    23489,
    11911,
    19816,
    13647,
    48413,
    46165,
    15171,
    37433
  ];

  static final List<int> serverDecryptKeys = [
    128079,
    164742,
    70235,
    106898,
    31544,
    2047,
    57011,
    10183,
    48413,
    46165,
    15171,
    37433
  ];

  static final List<int> serverEncryptKeys = [
    73326,
    109989,
    98843,
    171058,
    13169,
    19036,
    35482,
    29587,
    62004,
    64409,
    35374,
    64599
  ];

  static void initCryptSite(bool isServer) {
    if (isServer) {
      decryptKeys = serverDecryptKeys;
      encryptKeys = serverEncryptKeys;
    } else {
      decryptKeys = clientDecryptKeys;
      encryptKeys = clientEncryptKeys;
    }
  }

  static int encrypt(
      Uint8List? dest, int destIndex, Uint8List src, int srcIndex, int size) {
    int iOriSize;
    int iTempSize2;
    int iTempSize = size;
    int iDec = ((size + 7) ~/ 8);
    size = (iDec + iDec * 4) * 2 + iDec;
    if (dest != null) {
      iOriSize = iTempSize;
      for (int i = 0; i < iTempSize; i += 8, iOriSize -= 8, destIndex += 11) {
        iTempSize2 = iOriSize;
        if (iOriSize >= 8) {
          iTempSize2 = 8;
        }
        encryptBlock(
            dest, destIndex, src, srcIndex + i, iTempSize2, encryptKeys);
      }
    }
    return size;
  }

  static void encryptBlock(Uint8List dest, int destIndex, Uint8List src,
      int srcIndex, int size, List<int> keys) {
    Uint8List encValue = Uint8List(2);
    encValue[0] = size;
    encValue[0] ^= 0x3D;
    encValue[1] = 0xF8;

    for (int k = 0; k < size; ++k) {
      encValue[1] ^= src[srcIndex + k];
    }

    encValue[0] ^= encValue[1];
    addBits(dest, destIndex, 0x48, encValue, 0, 0x00, 0x10);

    List<int> encBuffer = List.filled(4, 0);
    List<int> cryptbuf = List.filled(4, 0);

    for (int i = 0; i < size; i += 2) {
      cryptbuf[i ~/ 2] = src[srcIndex + i];
      if (i + 1 < size) {
        cryptbuf[i ~/ 2] += src[srcIndex + i + 1] * 0x100;
      }
    }

    encBuffer[0] = ((keys[8] ^ cryptbuf[0]) * keys[4]) % keys[0];
    encBuffer[1] =
        ((keys[9] ^ (cryptbuf[1] ^ (encBuffer[0] & 0xFFFF))) * keys[5]) %
            keys[1];
    encBuffer[2] =
        ((keys[10] ^ (cryptbuf[2] ^ (encBuffer[1] & 0xFFFF))) * keys[6]) %
            keys[2];
    encBuffer[3] =
        ((keys[11] ^ (cryptbuf[3] ^ (encBuffer[2] & 0xFFFF))) * keys[7]) %
            keys[3];

    List<int> ringBackup = List.from(encBuffer);

    encBuffer[2] ^= keys[10] ^ (ringBackup[3] & 0xFFFF);
    encBuffer[1] ^= keys[9] ^ (ringBackup[2] & 0xFFFF);
    encBuffer[0] ^= keys[8] ^ (ringBackup[1] & 0xFFFF);

    Uint8List subring = Uint8List(16);
    for (int i = 0; i < 4; i++) {
      subring[i * 4] = (encBuffer[i] % 0x100);
      subring[i * 4 + 1] = (encBuffer[i] ~/ 0x100);
      subring[i * 4 + 2] = (encBuffer[i] ~/ 0x10000);
      subring[i * 4 + 3] = (encBuffer[i] ~/ 0x1000000);
    }

    addBits(dest, destIndex, 0x00, subring, 0, 0x00, 0x10);
    addBits(dest, destIndex, 0x10, subring, 0, 0x16, 0x02);
    addBits(dest, destIndex, 0x12, subring, 4, 0x00, 0x10);
    addBits(dest, destIndex, 0x22, subring, 4, 0x16, 0x02);
    addBits(dest, destIndex, 0x24, subring, 8, 0x00, 0x10);
    addBits(dest, destIndex, 0x34, subring, 8, 0x16, 0x02);
    addBits(dest, destIndex, 0x36, subring, 12, 0x00, 0x10);
    addBits(dest, destIndex, 0x46, subring, 12, 0x16, 0x02);
  }

  static int decryptBlock(Uint8List dest, int destIndex, Uint8List src,
      int srcIndex, List<int> keys) {
    List<int> temp = List.filled(4, 0);
    Uint8List decBuffer = Uint8List(16);

    addBits(decBuffer, 0, 0x00, src, srcIndex, 0x00, 0x10);
    addBits(decBuffer, 0, 0x16, src, srcIndex, 0x10, 0x02);
    addBits(decBuffer, 4, 0x00, src, srcIndex, 0x12, 0x10);
    addBits(decBuffer, 4, 0x16, src, srcIndex, 0x22, 0x02);
    addBits(decBuffer, 8, 0x00, src, srcIndex, 0x24, 0x10);
    addBits(decBuffer, 8, 0x16, src, srcIndex, 0x34, 0x02);
    addBits(decBuffer, 12, 0x00, src, srcIndex, 0x36, 0x10);
    addBits(decBuffer, 12, 0x16, src, srcIndex, 0x46, 0x02);

    for (int i = 0; i < 4; i++) {
      temp[i] = (decBuffer[i * 4] +
          decBuffer[i * 4 + 1] * 0x100 +
          decBuffer[i * 4 + 2] * 0x10000 +
          decBuffer[i * 4 + 3] * 0x1000000);
    }

    temp[2] ^= keys[10] ^ (temp[3] & 0xFFFF);
    temp[1] ^= keys[9] ^ (temp[2] & 0xFFFF);
    temp[0] ^= keys[8] ^ (temp[1] & 0xFFFF);

    List<int> temp1 = List.filled(4, 0);
    temp1[0] = (keys[8] ^ ((temp[0] * keys[4]) % keys[0]));
    temp1[1] = (keys[9] ^ ((temp[1] * keys[5]) % keys[1]) ^ (temp[0] & 0xFFFF));
    temp1[2] =
        (keys[10] ^ ((temp[2] * keys[6]) % keys[2]) ^ (temp[1] & 0xFFFF));
    temp1[3] =
        (keys[11] ^ ((temp[3] * keys[7]) % keys[3]) ^ (temp[2] & 0xFFFF));

    dest[destIndex] = temp1[0] % 0x100;
    dest[destIndex + 1] = temp1[0] ~/ 0x100;
    dest[destIndex + 2] = temp1[1] % 0x100;
    dest[destIndex + 3] = temp1[1] ~/ 0x100;
    dest[destIndex + 4] = temp1[2] % 0x100;
    dest[destIndex + 5] = temp1[2] ~/ 0x100;
    dest[destIndex + 6] = temp1[3] % 0x100;
    dest[destIndex + 7] = temp1[3] ~/ 0x100;

    Uint8List finale = Uint8List(2);
    addBits(finale, 0, 0, src, srcIndex, 0x48, 0x10);
    finale[0] ^= finale[1];
    finale[0] ^= 0x3D;

    int checkSum = 0xF8;
    for (int k = 0; k < 8; ++k) {
      checkSum ^= dest[destIndex + k];
    }

    return checkSum == finale[1] ? finale[0] : -1;
  }

  static int addBits(Uint8List dest, int destIndex, int destBitPos,
      Uint8List src, int srcIndex, int bitSourcePos, int bitLen) {
    int tempBufferLen =
        (((bitLen + bitSourcePos - 1) ~/ 8) + (1 - (bitSourcePos ~/ 8)));
    Uint8List tempBuffer = Uint8List(20);

    // Copy relevant bytes from source to tempBuffer
    tempBuffer.setRange(
        0, tempBufferLen, src.sublist(srcIndex + bitSourcePos ~/ 8));

    int sourceBufferBitLen = (bitLen + bitSourcePos) & 0x7;
    if (sourceBufferBitLen != 0) {
      tempBuffer[tempBufferLen - 1] &= (0xFF << (8 - sourceBufferBitLen));
    }

    bitSourcePos &= 0x7;
    shiftRight(tempBuffer, 0, tempBufferLen, bitSourcePos);
    shiftLeft(tempBuffer, 0, tempBufferLen + 1, destBitPos & 0x7);

    if ((destBitPos & 0x7) > bitSourcePos) {
      tempBufferLen++;
    }

    if (tempBufferLen > 0) {
      for (int i = 0; i < tempBufferLen; ++i) {
        dest[destIndex + i + (destBitPos ~/ 8)] |= tempBuffer[i];
      }
    }

    return bitLen + destBitPos;
  }

  static void shiftRight(
      Uint8List buffer, int bufferIndex, int len, int shift) {
    if (shift == 0) return;
    for (int i = 1; i < len; ++i) {
      buffer[bufferIndex] = (buffer[bufferIndex] << shift) |
          (buffer[bufferIndex + 1] >> (8 - shift));
      ++bufferIndex;
    }
    buffer[bufferIndex] <<= shift;
  }

  static void shiftLeft(Uint8List buffer, int bufferIndex, int len, int shift) {
    if (shift == 0) return;
    bufferIndex += len - 1;
    for (int i = 1; i < len; ++i) {
      buffer[bufferIndex] = (buffer[bufferIndex] >> shift) |
          (buffer[bufferIndex - 1] << (8 - shift));
      --bufferIndex;
    }
    buffer[bufferIndex] >>= shift;
  }

  static int decrypt(
      Uint8List? dest, int destIndex, Uint8List src, int srcIndex, int size) {
    int result = 0;
    int decLen = 0;
    if (dest == null) {
      return size * 8 ~/ 11;
    }
    if (size > 0) {
      while (decLen < size) {
        int tempResult =
            decryptBlock(dest, destIndex, src, srcIndex, decryptKeys);
        if (result < 0) {
          return result;
        }
        result += tempResult;
        decLen += 11;
        srcIndex += 11;
        destIndex += 8;
      }
    }
    return result;
  }
}

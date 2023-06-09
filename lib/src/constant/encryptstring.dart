import 'package:encrypt/encrypt.dart';
import 'package:gainer_crypto/crypto.dart';

final key = Key.fromUtf8('F)J@NcRfUjXn2r5u8x/A?D(G-KaPdSgV');
final iv = IV.fromUtf8('!QAZ2WSX#EDC4RFV');
String encrypt(plainText, iv, key) {
  final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));

  var encrypted = encrypter.encrypt(plainText, iv: IV.fromUtf8(iv));
  return encrypted.base16; // R4Pxi
}

String encrypthmac(plainText) {
  const key =
      "MFswDQYJKoZIhvcNAQEBBQADSgAwRwJASQdwSchKaYEv701AKF1uOSI5RUg5Pt9m";
  // Get Hash String of any CryptoType
  final sha1HashHMAC =
      grHMACHashString(GRCryptoTypeHMAC.hmacSHA512, plainText, key);
  // ignore: avoid_print
  print(sha1HashHMAC);

  return sha1HashHMAC; // R4Pxi
}

String decrypt(plainText) {
  final encrypter = Encrypter(AES(key));

  final decrypted = encrypter.decrypt64(plainText, iv: iv);

  return decrypted; //
}

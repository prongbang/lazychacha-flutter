import 'package:cryptography/cryptography.dart' as c;
import 'package:convert/convert.dart';

class KeyPair {
  final String pk;
  final String sk;

  KeyPair({this.pk = '', this.sk = ''});

  static Future<KeyPair> newKeyPair() async {
    final algorithm = c.X25519();
    final keyPair = await algorithm.newKeyPair();
    final publicKey = await keyPair.extractPublicKey();
    final secretKey = await keyPair.extractPrivateKeyBytes();
    return KeyPair(
      pk: hex.encode(publicKey.bytes),
      sk: hex.encode(secretKey),
    );
  }

  Future<String> sharedKey(String otherPk) async {
    final algorithm = c.X25519();
    final keyPair = c.SimpleKeyPairData(
      hex.decode(sk),
      publicKey: c.SimplePublicKey(hex.decode(pk), type: c.KeyPairType.x25519),
      type: c.KeyPairType.x25519,
    );
    final sharedSecretKey = await algorithm.sharedSecretKey(
      keyPair: keyPair,
      remotePublicKey: c.SimplePublicKey(
        hex.decode(otherPk),
        type: c.KeyPairType.x25519,
      ),
    );
    return hex.encode(await sharedSecretKey.extractBytes());
  }
}

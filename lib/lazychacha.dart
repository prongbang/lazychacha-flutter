library lazychacha;

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

abstract class LazyChaCha {
  /// Constructs a LazyChaCha.
  LazyChaCha();

  static LazyChaCha instance = LazyChaCha20Poly1305();

  Future<String> encrypt(String plaintext, String key);

  Future<String> decrypt(String ciphertext, String key);
}

class LazyChaCha20Poly1305 implements LazyChaCha {
  final _chaCha20 = Chacha20.poly1305Aead();

  @override
  Future<String> encrypt(String plaintext, String key) async {
    final secretKey = SecretKey(hex.decode(key));
    final secretBox =
        await _chaCha20.encryptString(plaintext, secretKey: secretKey);
    return hex.encode(secretBox.concatenation());
  }

  @override
  Future<String> decrypt(String ciphertext, String key) async {
    final secretKey = SecretKey(hex.decode(key));
    final cipherBytes = hex.decode(ciphertext);
    final secretBox = SecretBox.fromConcatenation(
      cipherBytes,
      nonceLength: 12,
      macLength: 16,
    );
    final plaintext =
        await _chaCha20.decryptString(secretBox, secretKey: secretKey);
    return plaintext;
  }
}

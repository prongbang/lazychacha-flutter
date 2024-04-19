import 'package:flutter/foundation.dart';
import 'package:lazychacha/keypair.dart';
import 'package:lazychacha/lazychacha.dart';

void main() async {
  final lazychacha = LazyChaCha.instance;

  // Generate KeyPair
  final clientKeyPair = await KeyPair.newKeyPair();
  final serverKeyPair = await KeyPair.newKeyPair();

  // Key Exchange
  final clientSharedKey = await clientKeyPair.sharedKey(serverKeyPair.pk);
  final serverSharedKey = await serverKeyPair.sharedKey(clientKeyPair.pk);

  // Payload
  const message = 'Hello lazychacha';

  // Encrypt with client
  final ciphertext = await lazychacha.encrypt(message, clientSharedKey);

  // Decrypt with server
  final plaintext = await lazychacha.decrypt(ciphertext, serverSharedKey);

  // Output
  if (kDebugMode) {
    print('Output: $plaintext');
  } // Output: Hello lazychacha
}

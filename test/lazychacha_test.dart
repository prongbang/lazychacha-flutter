import 'package:flutter_test/flutter_test.dart';
import 'package:lazychacha/keypair.dart';

import 'package:lazychacha/lazychacha.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LazyChaCha lazyChaCha;

  setUp(() {
    lazyChaCha = LazyChaCha.instance;
  });

  test('Should return ciphertext when encrypt success', () async {
    // Given
    const sharedKey =
        'e4f7fe3c8b4066490f8ffde56f080c70629ff9731b60838015027c4687303b1d';
    const plaintext =
        '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIn0.rTCH8cLoGxAm_xw68z-zXVKi9ie6xJn9tnVWjd_9ftE"}';

    // When
    final actual = await lazyChaCha.encrypt(plaintext, sharedKey);

    // Then
    expect(actual, isNotNull);
    print(actual);
  });

  test('Should return plaintext when decrypt success', () async {
    // Given
    const sharedKey =
        '5330d653f2d3f33b393ca5a88bacb3ac502e01b07b4fa063ebf77654937e1013';
    const ciphertext =
        '7581ef119758e7830ef23b3b0b5034a75d891df8e27d1cb59ab16d9a1ae9174f36a577e6aa88e67b113872007f5343ffd4a1f14a14fb20b55b69866fa111d43707a41623d803c0a6e1639838f488760839bf935a752d1a5e94ae1e3d451422d032e0bad5e1dac1f8e8bf2f008a0a960c625262bff8b88400826d88a3da347381c9e7549e040b42d51c';
    const plaintext =
        '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIn0.rTCH8cLoGxAm_xw68z-zXVKi9ie6xJn9tnVWjd_9ftE"}';

    // When
    final actual = await lazyChaCha.decrypt(ciphertext, sharedKey);

    // Then
    expect(actual, plaintext);
  });

  test(
    'Should return ciphertext and plaintext when encrypt and decrypt success',
    () async {
      // Given
      final clientKp = await KeyPair.newKeyPair();
      final serverKp = await KeyPair.newKeyPair();
      final clientSharedKey = await clientKp.sharedKey(serverKp.pk);
      const plaintext =
          '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIn0.rTCH8cLoGxAm_xw68z-zXVKi9ie6xJn9tnVWjd_9ftE"}';

      // When
      final actualCipherText = await lazyChaCha.encrypt(plaintext, clientSharedKey);
      final actualPlainText =
          await lazyChaCha.decrypt(actualCipherText, clientSharedKey);

      // Then
      expect(actualPlainText, plaintext);
    },
  );
}

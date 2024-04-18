import 'package:flutter_test/flutter_test.dart';
import 'package:lazychacha/keypair.dart';

void main() {
  test('Should return keypair when new keypair success', () async {
    // Given & When
    final keyPair = await KeyPair.newKeyPair();

    // Then
    expect(keyPair.pk, isNotNull);
    expect(keyPair.sk, isNotNull);
  });

  test('Should return shared key when exchange key success', () async {
    // Given
    final clientKeyPair = await KeyPair.newKeyPair();
    final serverKeyPair = await KeyPair.newKeyPair();

    // When
    final clientSharedKey = await clientKeyPair.sharedKey(serverKeyPair.pk);
    final serverSharedKey = await serverKeyPair.sharedKey(clientKeyPair.pk);

    // Then
    expect(clientSharedKey, serverSharedKey);
  });
}

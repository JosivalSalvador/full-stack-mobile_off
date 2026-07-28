import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/features/unlock/domain/services/key_derivation.dart';

void main() {
  // Cheap Argon2id parameters, used only in tests to keep the suite fast.
  // Production code relies on the OWASP-recommended defaults instead.
  final testAlgorithm = Argon2id(
    parallelism: 1,
    memory: 8,
    iterations: 1,
    hashLength: 32,
  );

  late KeyDerivation keyDerivation;

  setUp(() {
    keyDerivation = KeyDerivation(algorithm: testAlgorithm);
  });

  group('generateSalt', () {
    test('returns 16 bytes', () {
      final salt = keyDerivation.generateSalt();
      expect(salt.length, 16);
    });

    test('returns a different value on each call', () {
      final saltA = keyDerivation.generateSalt();
      final saltB = keyDerivation.generateSalt();
      expect(saltA, isNot(equals(saltB)));
    });
  });

  group('deriveHash', () {
    test('is deterministic for the same password and salt', () async {
      final salt = keyDerivation.generateSalt();

      final hashA = await keyDerivation.deriveHash(
        password: 'correct horse battery staple',
        salt: salt,
      );
      final hashB = await keyDerivation.deriveHash(
        password: 'correct horse battery staple',
        salt: salt,
      );

      expect(hashA, hashB);
    });

    test('differs when the salt changes', () async {
      const password = 'correct horse battery staple';

      final hashA = await keyDerivation.deriveHash(
        password: password,
        salt: Uint8List.fromList(List.filled(16, 1)),
      );
      final hashB = await keyDerivation.deriveHash(
        password: password,
        salt: Uint8List.fromList(List.filled(16, 2)),
      );

      expect(hashA, isNot(equals(hashB)));
    });

    test('differs when the password changes', () async {
      final salt = keyDerivation.generateSalt();

      final hashA = await keyDerivation.deriveHash(
        password: 'password one',
        salt: salt,
      );
      final hashB = await keyDerivation.deriveHash(
        password: 'password two',
        salt: salt,
      );

      expect(hashA, isNot(equals(hashB)));
    });
  });

  group('verifyPassword', () {
    test('returns true for the correct password', () async {
      final salt = keyDerivation.generateSalt();
      const password = 'correct horse battery staple';

      final hash = await keyDerivation.deriveHash(
        password: password,
        salt: salt,
      );

      final isValid = await keyDerivation.verifyPassword(
        password: password,
        salt: salt,
        expectedHash: hash,
      );

      expect(isValid, isTrue);
    });

    test('returns false for an incorrect password', () async {
      final salt = keyDerivation.generateSalt();

      final hash = await keyDerivation.deriveHash(
        password: 'correct horse battery staple',
        salt: salt,
      );

      final isValid = await keyDerivation.verifyPassword(
        password: 'wrong password',
        salt: salt,
        expectedHash: hash,
      );

      expect(isValid, isFalse);
    });
  });
}
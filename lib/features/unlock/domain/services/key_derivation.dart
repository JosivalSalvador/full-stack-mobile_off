import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Handles deriving and verifying the vault's master key from the user's
/// master password, using Argon2id.
///
/// The derived key never leaves this class as anything other than raw bytes;
/// callers only ever see the base64-encoded hash used for storage/comparison.
class KeyDerivation {
  /// Creates a [KeyDerivation] service, optionally overriding the Argon2id
  /// [algorithm] instance (mainly useful for testing with cheaper params).
  KeyDerivation({Argon2id? algorithm})
    : _algorithm =
          algorithm ??
          Argon2id(
            parallelism: 4,
            memory: 19456, // ~19 MB, OWASP-recommended minimum for Argon2id
            iterations: 2,
            hashLength: 32,
          );

  final Argon2id _algorithm;
  final Random _random = Random.secure();

  /// Generates a new random salt, to be stored alongside the resulting hash.
  Uint8List generateSalt() {
    return Uint8List.fromList(
      List<int>.generate(16, (_) => _random.nextInt(256)),
    );
  }

  /// Derives a key from [password] and [salt], returning it as a
  /// base64-encoded string suitable for storage in the vault metadata table.
  Future<String> deriveHash({
    required String password,
    required Uint8List salt,
  }) async {
    final secretKey = await _algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final bytes = await secretKey.extractBytes();
    return base64Encode(bytes);
  }

  /// Verifies whether [password], combined with [salt], produces the same
  /// hash as [expectedHash]. Never compares plain-text passwords directly.
  Future<bool> verifyPassword({
    required String password,
    required Uint8List salt,
    required String expectedHash,
  }) async {
    final actualHash = await deriveHash(password: password, salt: salt);
    return actualHash == expectedHash;
  }
}

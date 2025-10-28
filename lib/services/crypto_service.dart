import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';

class CryptoService {
  static const _secureStorage = FlutterSecureStorage();
  static const String _keyStorageKey = 'sms_encryption_key';
  static const String _ivStorageKey = 'sms_encryption_iv';

  // Initialize and get or generate encryption key
  static Future<void> init() async {
    var key = await _secureStorage.read(key: _keyStorageKey);
    if (key == null) {
      // Generate a new 256-bit key
      final keyBytes = _generateRandomBytes(32); // 256 bits
      key = base64Encode(keyBytes);
      await _secureStorage.write(key: _keyStorageKey, value: key);
    }
  }

  static List<int> _generateRandomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }

  static Future<String> _getKey() async {
    var key = await _secureStorage.read(key: _keyStorageKey);
    if (key == null) {
      await init();
      key = await _secureStorage.read(key: _keyStorageKey);
    }
    return key!;
  }

  // Encrypt SMS token using AES-256-GCM
  static Future<String> encryptSmsToken(String plaintext) async {
    try {
      final keyString = await _getKey();
      final key = Key.fromBase64(keyString);
      
      // Generate a random IV for each encryption
      final iv = IV.fromSecureRandom(16);
      
      // Use AES in GCM mode
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      final encrypted = encrypter.encrypt(plaintext, iv: iv);
      
      // Combine IV and ciphertext for transmission
      final combined = base64Encode(iv.bytes) + ':' + encrypted.base64;
      return combined;
    } catch (e) {
      print('Encryption error: $e');
      rethrow;
    }
  }

  // Decrypt SMS token using AES-256-GCM
  static Future<String> decryptSmsToken(String cipherText) async {
    try {
      final keyString = await _getKey();
      final key = Key.fromBase64(keyString);
      
      // Split IV and ciphertext
      final parts = cipherText.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid encrypted format');
      }
      
      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      
      // Decrypt using AES-GCM
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      
      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      rethrow;
    }
  }

  // Encrypt transaction payload
  static Future<String> encryptPayload(Map<String, dynamic> payload) async {
    final jsonString = jsonEncode(payload);
    return await encryptSmsToken(jsonString);
  }

  // Decrypt transaction payload
  static Future<Map<String, dynamic>> decryptPayload(String encrypted) async {
    final decrypted = await decryptSmsToken(encrypted);
    return jsonDecode(decrypted) as Map<String, dynamic>;
  }
}

import 'package:flutter_blue/flutter_blue.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';
import 'crypto_service.dart';

class ChannelService {
  static FlutterBlue? _flutterBlue;
  static StreamSubscription? _scanSubscription;
  static List<BluetoothDevice> _discoveredDevices = [];

  static Future<void> init() async {
    try {
      _flutterBlue = FlutterBlue.instance;
    } catch (e) {
      print('Bluetooth initialization failed: $e');
    }
  }

  // Bluetooth operations
  static Future<List<Map<String, String>>> scanBluetoothDevices({Duration timeout = const Duration(seconds: 10)}) async {
    if (_flutterBlue == null) {
      throw Exception('Bluetooth not initialized');
    }

    _discoveredDevices.clear();
    final devices = <Map<String, String>>[];

    try {
      // Start scanning
      await _flutterBlue!.startScan(timeout: timeout);

      // Listen to scan results
      _scanSubscription = _flutterBlue!.scanResults.listen((results) {
        for (var result in results) {
          if (!_discoveredDevices.contains(result.device)) {
            _discoveredDevices.add(result.device);
            devices.add({
              'id': result.device.id.toString(),
              'name': result.device.name.isNotEmpty ? result.device.name : 'Unknown Device',
              'rssi': result.rssi.toString(),
            });
          }
        }
      });

      await Future.delayed(timeout);
      await _flutterBlue!.stopScan();
      await _scanSubscription?.cancel();

      return devices;
    } catch (e) {
      print('Bluetooth scan error: $e');
      return [];
    }
  }

  static Future<bool> sendViaBluetooth(String deviceId, String payload) async {
    if (_flutterBlue == null) {
      throw Exception('Bluetooth not initialized');
    }

    try {
      final device = _discoveredDevices.firstWhere(
        (d) => d.id.toString() == deviceId,
        orElse: () => throw Exception('Device not found'),
      );

      // Connect to device
      await device.connect(timeout: Duration(seconds: 10));

      // Discover services
      final services = await device.discoverServices();

      // Find payment service (using a custom UUID in production)
      // For demo, we'll simulate the send
      print('Sending via Bluetooth to ${device.name}: $payload');

      await device.disconnect();
      return true;
    } catch (e) {
      print('Bluetooth send error: $e');
      return false;
    }
  }

  // NFC operations
  static Future<bool> isNfcAvailable() async {
    try {
      return await NfcManager.instance.isAvailable();
    } catch (e) {
      print('NFC availability check error: $e');
      return false;
    }
  }

  static Future<bool> sendViaNfc(String payload) async {
    try {
      final isAvailable = await isNfcAvailable();
      if (!isAvailable) {
        throw Exception('NFC not available');
      }

      final completer = Completer<bool>();

      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            // Write NDEF message
            final ndef = Ndef.from(tag);
            if (ndef == null || !ndef.isWritable) {
              completer.complete(false);
              return;
            }

            final message = NdefMessage([
              NdefRecord.createText(payload),
            ]);

            await ndef.write(message);
            completer.complete(true);
          } catch (e) {
            print('NFC write error: $e');
            completer.complete(false);
          } finally {
            await NfcManager.instance.stopSession();
          }
        },
      );

      return await completer.future.timeout(
        Duration(seconds: 30),
        onTimeout: () {
          NfcManager.instance.stopSession();
          return false;
        },
      );
    } catch (e) {
      print('NFC send error: $e');
      return false;
    }
  }

  static Future<String?> receiveViaNfc() async {
    try {
      final isAvailable = await isNfcAvailable();
      if (!isAvailable) {
        throw Exception('NFC not available');
      }

      final completer = Completer<String?>();

      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null) {
              completer.complete(null);
              return;
            }

            final message = ndef.cachedMessage;
            if (message == null || message.records.isEmpty) {
              completer.complete(null);
              return;
            }

            final payload = String.fromCharCodes(message.records.first.payload);
            completer.complete(payload);
          } catch (e) {
            print('NFC read error: $e');
            completer.complete(null);
          } finally {
            await NfcManager.instance.stopSession();
          }
        },
      );

      return await completer.future.timeout(
        Duration(seconds: 30),
        onTimeout: () {
          NfcManager.instance.stopSession();
          return null;
        },
      );
    } catch (e) {
      print('NFC receive error: $e');
      return null;
    }
  }

  // SMS operations
  static Future<bool> sendViaSms(String phoneNumber, String payload) async {
    try {
      // Encrypt payload
      final encryptedPayload = CryptoService.encryptSmsToken(payload);

      // In production, use SMS plugin to send
      // For demo, just log
      print('Sending encrypted SMS to $phoneNumber: $encryptedPayload');

      // TODO: Implement actual SMS sending
      // await sendSMS(message: encryptedPayload, recipients: [phoneNumber]);

      return true;
    } catch (e) {
      print('SMS send error: $e');
      return false;
    }
  }

  static Future<String?> decryptSmsPayload(String encryptedPayload) async {
    try {
      return await CryptoService.decryptSmsToken(encryptedPayload);
    } catch (e) {
      print('SMS decrypt error: $e');
      return null;
    }
  }

  static void dispose() {
    _scanSubscription?.cancel();
  }
}

import 'package:local_auth/local_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import '../models/user.dart';
import 'hive_service.dart';
import 'firebase_service.dart';

class AuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static String? _pendingOtp;
  static DateTime? _otpExpiry;

  // Generate and send OTP (in demo mode, just store it)
  static Future<String> sendOtp(String phone) async {
    final otp = _generateOtp();
    _pendingOtp = otp;
    _otpExpiry = DateTime.now().add(Duration(minutes: 5));
    
    // TODO: In production, send via SMS/Firebase
    print('OTP for $phone: $otp'); // Demo mode
    return otp; // Return for demo purposes
  }

  static String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  static bool verifyOtp(String otp) {
    if (_pendingOtp == null || _otpExpiry == null) return false;
    if (DateTime.now().isAfter(_otpExpiry!)) {
      _pendingOtp = null;
      return false;
    }
    return _pendingOtp == otp;
  }

  static Future<AppUser> register({
    required String name,
    required String username,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    // Check one-device enforcement
    final existingUser = HiveService.getCurrentUser();
    if (existingUser != null) {
      throw Exception('Device already registered. Please logout first.');
    }

    // Hash password
    final hashedPassword = _hashPassword(password);

    // Create user
    final deviceId = DateTime.now().millisecondsSinceEpoch.toString();
    final user = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      username: username,
      phone: phone,
      role: role,
      deviceId: deviceId,
      createdAt: DateTime.now(),
    );

    // Save locally
    await HiveService.saveUser(user);
    await HiveService.saveCredentials(username, hashedPassword);

    // Sync to Firebase
    try {
      await FirebaseService.registerUser(user, hashedPassword);
    } catch (e) {
      // Offline mode - will sync later
      print('Offline registration: $e');
    }

    return user;
  }

  static Future<AppUser?> loginOffline(String username, String password) async {
    final credentials = await HiveService.getCredentials();
    if (credentials == null) return null;

    if (credentials['username'] != username) return null;

    final hashedPassword = _hashPassword(password);
    if (credentials['password'] != hashedPassword) return null;

    return HiveService.getCurrentUser();
  }

  static Future<AppUser?> loginOnline(String username, String password) async {
    try {
      final user = await FirebaseService.loginUser(username, password);
      if (user != null) {
        await HiveService.saveUser(user);
        await HiveService.saveCredentials(username, _hashPassword(password));
      }
      return user;
    } catch (e) {
      // Fall back to offline login
      return loginOffline(username, password);
    }
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static Future<bool> authenticateBiometric() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return false;

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to proceed with transaction',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return isAuthenticated;
    } catch (e) {
      print('Biometric auth error: $e');
      return false;
    }
  }

  static Future<bool> verifyPin(String pin, String correctPin) async {
    return pin == correctPin;
  }

  static Future<bool> canUseBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    await HiveService.deleteUser();
  }
}

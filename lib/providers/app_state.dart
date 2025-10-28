import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/user.dart';
import '../services/hive_service.dart';
import '../services/firebase_service.dart';

class AppState extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isOnline = false;
  bool _isSyncing = false;
  ThemeMode _themeMode = ThemeMode.light;
  Color _accentColor = Colors.blue;
  String _language = 'en'; // 'en' or 'hi'
  bool _biometricEnabled = true;
  int _autoLockMinutes = 5;
  DateTime? _lastActivityTime;
  FlutterTts _tts = FlutterTts();

  AppUser? get currentUser => _currentUser;
  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  String get language => _language;
  bool get biometricEnabled => _biometricEnabled;
  int get autoLockMinutes => _autoLockMinutes;

  AppState() {
    _initTts();
    _checkConnectivity();
  }

  void _initTts() async {
    await _tts.setLanguage(_language == 'en' ? 'en-US' : 'hi-IN');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  void _checkConnectivity() {
    // TODO: Implement actual connectivity check
    // For demo, simulate offline mode
    _isOnline = false;
    notifyListeners();
  }

  void setUser(AppUser user) {
    _currentUser = user;
    _lastActivityTime = DateTime.now();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateActivity() {
    _lastActivityTime = DateTime.now();
  }

  bool shouldAutoLock() {
    if (_lastActivityTime == null) return false;
    final diff = DateTime.now().difference(_lastActivityTime!);
    return diff.inMinutes >= _autoLockMinutes;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    HiveService.saveThemeMode(mode);
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    HiveService.saveAccentColor(color);
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    _tts.setLanguage(lang == 'en' ? 'en-US' : 'hi-IN');
    HiveService.saveLanguage(lang);
    notifyListeners();
  }

  void setBiometricEnabled(bool enabled) {
    _biometricEnabled = enabled;
    HiveService.saveBiometricEnabled(enabled);
    notifyListeners();
  }

  void setAutoLockMinutes(int minutes) {
    _autoLockMinutes = minutes;
    HiveService.saveAutoLockMinutes(minutes);
    notifyListeners();
  }

  void setOnlineStatus(bool online) {
    _isOnline = online;
    notifyListeners();
    if (online) {
      _syncTransactions();
    }
  }

  Future<void> _syncTransactions() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();

    try {
      final unsyncedTxs = await HiveService.getUnsyncedTransactions();
      int succeeded = 0;
      int failed = 0;

      for (var tx in unsyncedTxs) {
        try {
          await FirebaseService.syncTransaction(tx);
          tx.synced = true;
          await tx.save();
          succeeded++;
        } catch (e) {
          failed++;
        }
      }

      if (succeeded > 0 || failed > 0) {
        await speak('Sync completed. $succeeded succeeded, $failed failed.');
      }
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> loadSettings() async {
    _themeMode = await HiveService.getThemeMode();
    _accentColor = await HiveService.getAccentColor();
    _language = await HiveService.getLanguage();
    _biometricEnabled = await HiveService.getBiometricEnabled();
    _autoLockMinutes = await HiveService.getAutoLockMinutes();
    notifyListeners();
  }
}

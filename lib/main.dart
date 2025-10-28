import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/enhanced_auth_screen.dart';
import 'screens/dashboard.dart';
import 'services/hive_service.dart';
import 'services/firebase_service.dart';
import 'services/crypto_service.dart';
import 'services/channel_service.dart';
import 'services/notification_service.dart';
import 'providers/app_state.dart';

// Toggle demoMode to true to simulate hardware actions without real Bluetooth/NFC/SMS.
const bool demoMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize all services
  try {
    await HiveService.init();
    print('Hive initialized');
  } catch (e) {
    print('Hive init error: $e');
  }
  
  try {
    await FirebaseService.init();
    print('Firebase initialized');
  } catch (e) {
    print('Firebase init error (continuing in offline mode): $e');
  }
  
  try {
    await CryptoService.init();
    print('Crypto initialized');
  } catch (e) {
    print('Crypto init error: $e');
  }
  
  try {
    await ChannelService.init();
    print('Channel service initialized');
  } catch (e) {
    print('Channel service init error: $e');
  }
  
  try {
    await NotificationService.init();
    print('Notification service initialized');
  } catch (e) {
    print('Notification service init error: $e');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..loadSettings(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Paywave',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSeed(
                seedColor: appState.accentColor,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSeed(
                seedColor: appState.accentColor,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: appState.themeMode,
            home: EnhancedAuthScreen(demoMode: demoMode),
            routes: {
              '/dashboard': (_) => DashboardScreen(demoMode: demoMode),
            },
          );
        },
      ),
    );
  }
}

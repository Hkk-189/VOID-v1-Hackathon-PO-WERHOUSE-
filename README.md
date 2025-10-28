# Paywave - Offline-First Payment App

A comprehensive Flutter application for offline-first payments with multi-channel support (Bluetooth, NFC, SMS), Firebase cloud sync, and end-to-end encryption.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 2.17.0)
- Android Studio / Xcode for mobile development
- Physical device recommended for Bluetooth/NFC testing

### Installation

1. **Clone and navigate to project:**
```bash
cd /home/hkk/test12/hackathon:VOID:v1
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate Hive adapters (if not already generated):**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app:**
```bash
# For Android device
flutter run -d <device-id>

# For web (demo mode)
flutter run -d chrome

# For Linux desktop
flutter run -d linux
```

## ✨ Features Implemented

### Core Features
- ✅ **Dual Roles**: Sender and Receiver (single-role per account)
- ✅ **Offline-First**: Hive local storage with AES encryption
- ✅ **Cloud Sync**: Firebase Firestore auto-sync when online
- ✅ **Multi-Channel Payments**: Bluetooth, NFC, encrypted SMS (AES-256-GCM)
- ✅ **Security**: Biometric + PIN authentication, encrypted credentials
- ✅ **Demo Mode**: Enabled by default for testing without hardware

### Authentication & Security
- ✅ Complete registration flow with OTP verification
- ✅ Role selection (Sender/Receiver)
- ✅ Real-time form validation
- ✅ Password hashing (SHA-256)
- ✅ One-device-per-account enforcement
- ✅ Offline login support
- ✅ Biometric authentication ready
- ✅ Secure key storage (flutter_secure_storage)

### Data & Storage
- ✅ Encrypted Hive database
- ✅ Transaction models (successful, pending, cancelled)
- ✅ User models with device ID
- ✅ Settings persistence
- ✅ Background sync with retry logic

### UI/UX
- ✅ Modern Material Design 3
- ✅ Light/Dark theme support
- ✅ Custom accent colors
- ✅ Multi-language (English/Hindi)
- ✅ Text-to-Speech (TTS) confirmations
- ✅ Animated transitions
- ✅ Loading indicators
- ✅ Local notifications

### Services
- ✅ **HiveService**: Encrypted local storage
- ✅ **FirebaseService**: Cloud sync and auth
- ✅ **AuthService**: Complete authentication system
- ✅ **CryptoService**: AES-256-GCM encryption
- ✅ **ChannelService**: Bluetooth, NFC, SMS support
- ✅ **NotificationService**: Local notifications

## 📱 Demo Mode Usage

Demo mode is enabled by default (`demoMode = true` in `lib/main.dart`).

### Testing Registration:
1. Launch app
2. Select role (Sender/Receiver)
3. Fill registration form
4. Click "Send OTP" - OTP will be displayed in a snackbar
5. Enter the 6-digit OTP
6. Complete registration

### Demo OTP:
The OTP is automatically generated and displayed for 5 seconds in demo mode.

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point with service initialization
├── models/                   # Data models with Hive adapters
│   ├── user.dart            # User model (with role)
│   ├── user.g.dart          # Generated Hive adapter
│   ├── transaction.dart     # Transaction model
│   └── transaction.g.dart   # Generated Hive adapter
├── services/                 # Business logic services
│   ├── hive_service.dart    # Local encrypted storage
│   ├── firebase_service.dart # Cloud sync
│   ├── auth_service.dart    # Authentication & biometric
│   ├── crypto_service.dart  # AES-256-GCM encryption
│   ├── channel_service.dart # Bluetooth/NFC/SMS
│   └── notification_service.dart # Local notifications
├── providers/                # State management
│   └── app_state.dart       # Global app state
├── screens/                  # UI screens
│   ├── enhanced_auth_screen.dart # Registration & login
│   ├── dashboard.dart       # Main dashboard
│   ├── send_screen.dart     # Send payment
│   ├── receive_screen.dart  # Receive payment
│   ├── history_screen.dart  # Transaction history
│   └── settings_screen.dart # App settings
├── widgets/                  # Reusable widgets
│   └── custom_keypad.dart   # Numeric keypad
└── utils/                    # Utilities
    └── localization.dart    # EN/HI translations
```

## 🔒 Security Features

- **AES-256-GCM** encryption for SMS tokens
- **Hive database encryption** with secure key storage
- **Password hashing** using SHA-256
- **Biometric authentication** support
- **Device ID enforcement** (one device per account)
- **Encrypted credentials** storage
- **Secure random IV** generation per encryption

## 🌐 Multi-Language Support

Toggle between English and Hindi using the language button in the app bar.

Supported languages:
- 🇬🇧 English (en)
- 🇮🇳 Hindi (hi)

## 📋 Configuration Notes

### Firebase Setup (Required for Production)
1. Create Firebase project at https://console.firebase.google.com
2. Add Android app and download `google-services.json` to `android/app/`
3. Add iOS app and download `GoogleService-Info.plist` to `ios/Runner/`
4. Enable Authentication and Firestore in Firebase console

### Permissions (Android)
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
<uses-permission android:name="android.permission.NFC"/>
<uses-permission android:name="android.permission.SEND_SMS"/>
<uses-permission android:name="android.permission.RECEIVE_SMS"/>
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

## 🐛 Known Issues

1. **Linux Build**: flutter_secure_storage_linux has compilation issues on some systems
2. **flutter_blue**: Deprecated, consider migrating to flutter_blue_plus
3. **Firebase**: Requires configuration files for production use

## 📚 Documentation

- See `IMPLEMENTATION_STATUS.md` for detailed feature status
- Check inline code comments for implementation details
- Review service files for API documentation

## 🧪 Testing

Demo mode allows testing all flows without physical hardware:
- OTP is displayed in snackbar
- Bluetooth/NFC operations are simulated
- SMS encryption is functional but sending is mocked

## 📄 License

This is a demo/scaffold project for educational purposes.


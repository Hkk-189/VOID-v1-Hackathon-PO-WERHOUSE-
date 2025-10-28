# 🚀 Paywave - Quick Start Guide

## Prerequisites Check
```bash
flutter --version  # Should be >= 3.0.0
flutter doctor     # Check for issues
```

## Installation (5 minutes)

### Step 1: Install Dependencies
```bash
cd /home/hkk/test12/hackathon:VOID:v1
flutter pub get
```

### Step 2: Generate Hive Adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Check Available Devices
```bash
flutter devices
```

### Step 4: Run the App
```bash
# For Android device
flutter run -d <device-id>

# For Chrome (web demo)
flutter run -d chrome

# For Linux desktop (may have issues)
flutter run -d linux
```

## 🎮 Demo Mode Testing (2 minutes)

### Test Registration Flow

1. **Launch App**
   - App opens to Enhanced Auth Screen
   - Language button (🌐) in top-right

2. **Select Role**
   - Choose "Sender" or "Receiver"
   - Radio buttons in card at top

3. **Fill Registration Form**
   ```
   Name: Test User
   Username: testuser
   Phone: 1234567890
   Password: test123
   Confirm Password: test123
   ```

4. **Send OTP**
   - Click "Send OTP" button
   - **IMPORTANT**: OTP appears in snackbar at bottom for 5 seconds
   - Example: "Demo OTP: 123456"
   - Copy this OTP quickly!

5. **Enter OTP**
   - OTP field appears
   - Enter the 6-digit OTP from snackbar
   - Resend timer shows 60 seconds countdown

6. **Complete Registration**
   - Click "Register" button
   - TTS says "Registration successful"
   - Navigates to Dashboard

### Test Login Flow

1. **Switch to Login**
   - Click "Already have an account? Login"

2. **Enter Credentials**
   ```
   Username: testuser
   Password: test123
   ```

3. **Login**
   - Click "Login" button
   - TTS says "Login successful"
   - Navigates to Dashboard

### Test Language Toggle

1. **Click Language Button** (🌐 in app bar)
2. **Toggles between English and Hindi**
3. **All UI text changes immediately**

### Test Theme Toggle

1. **Go to Settings** (from Dashboard)
2. **Toggle Dark Theme switch**
3. **App theme changes immediately**

## 📱 What Works in Demo Mode

### ✅ Fully Functional
- Registration with OTP
- Login (offline)
- Role selection
- Form validation
- Password hashing
- Theme switching
- Language toggle
- TTS announcements
- Encrypted storage
- Device ID generation

### ⚠️ Simulated (No Hardware Needed)
- OTP sending (displayed in snackbar)
- Bluetooth scanning (placeholder)
- NFC operations (placeholder)
- SMS sending (logged to console)

## 🔍 Verification Steps

### Check Data Persistence
1. Register a user
2. Close app completely
3. Reopen app
4. Login with same credentials
5. ✅ Should work (data stored in Hive)

### Check Encryption
1. Register a user
2. Check app data directory
3. ✅ All Hive files are encrypted

### Check Multi-Language
1. Switch to Hindi
2. Close app
3. Reopen app
4. ✅ Should remember Hindi preference

### Check Theme
1. Switch to Dark mode
2. Close app
3. Reopen app
4. ✅ Should remember Dark theme

## 🐛 Troubleshooting

### Issue: OTP Not Visible
**Solution**: OTP appears in snackbar at bottom for 5 seconds. Watch carefully!

### Issue: "Device already registered"
**Solution**: This is the one-device-per-account enforcement working. To reset:
```bash
# Clear app data
flutter clean
flutter pub get
flutter run
```

### Issue: Build Errors
**Solution**: 
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Issue: Linux Build Fails
**Solution**: Use Android device or Chrome instead:
```bash
flutter run -d chrome
```

### Issue: Firebase Errors in Console
**Solution**: Normal in demo mode. Firebase is not configured. App works offline.

## 📊 Console Output

### Expected Messages
```
Hive initialized
Firebase init error (continuing in offline mode): ...  ← Normal
Crypto initialized
Channel service initialized
Notification service initialized
OTP for 1234567890: 123456  ← Demo OTP
```

### Success Indicators
- ✅ "Hive initialized"
- ✅ "Crypto initialized"
- ✅ "Channel service initialized"
- ✅ "Notification service initialized"
- ✅ "Registration successful" (TTS)
- ✅ "Login successful" (TTS)

## 🎯 Quick Feature Test Checklist

- [ ] App launches successfully
- [ ] Registration form appears
- [ ] Role selection works
- [ ] Form validation works (try empty fields)
- [ ] OTP appears in snackbar
- [ ] OTP verification works
- [ ] Registration completes
- [ ] Dashboard appears
- [ ] Language toggle works
- [ ] Theme toggle works (in Settings)
- [ ] Logout works
- [ ] Login works with saved credentials
- [ ] TTS announcements work

## 🔐 Security Features to Verify

1. **Password Hashing**
   - Passwords never stored in plain text
   - Check Hive database (encrypted)

2. **Data Encryption**
   - All Hive boxes encrypted
   - Keys stored in flutter_secure_storage

3. **Device Enforcement**
   - Try registering twice
   - Should show "Device already registered"

4. **Offline Login**
   - Turn off internet
   - Login should still work

## 📞 Need Help?

1. **Check Documentation**
   - README.md - Full documentation
   - IMPLEMENTATION_STATUS.md - Feature status
   - COMPLETION_SUMMARY.md - What's implemented

2. **Check Console**
   - Look for error messages
   - Check initialization messages

3. **Common Issues**
   - OTP not visible → Watch snackbar at bottom
   - Build errors → Run flutter clean
   - Device already registered → Clear app data

## 🎉 Success!

If you can:
- ✅ Register a new user
- ✅ See OTP in snackbar
- ✅ Complete registration
- ✅ Login with credentials
- ✅ Toggle language
- ✅ Toggle theme

**Congratulations! The app is working correctly! 🎊**

---

**Demo Mode**: ✅ Enabled by default
**Hardware Required**: ❌ No (for basic testing)
**Internet Required**: ❌ No (offline-first)
**Time to Test**: ⏱️ 2-5 minutes

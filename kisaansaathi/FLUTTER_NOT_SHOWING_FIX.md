# 🔧 Fix: Flutter Not Showing Predictions

## ✅ What I've Added

### 1. Better Error Handling
- Added timeout (30 seconds)
- Added detailed error messages
- Added console logging

### 2. Connection Test Button
A blue "Test Server Connection" button has been added to the Yield Prediction screen.

**Use it to:**
- Test if Flutter can reach the server
- See exact error messages
- Verify URL is correct

## 🚀 How to Fix

### Step 1: Hot Restart Flutter

```bash
# In your Flutter terminal, press:
R  # Capital R for hot restart
```

Or stop and restart:
```bash
flutter run
```

### Step 2: Test Connection

1. Open the app
2. Go to "Yield Prediction"
3. **Tap the blue "Test Server Connection" button**
4. See what happens:

**✅ If it says "Connected!"**
- Server is reachable
- URL is correct
- Try making a prediction

**❌ If it says "Connection Failed"**
- Read the error message
- Follow solutions below

### Step 3: Check Flutter Console

When you tap "Predict Yield", look at the Flutter console for:

```
Making prediction request...
State: Punjab, Crop: Wheat, Season: Rabi
Response status: 200
Response body: {...}
```

## 🔍 Common Errors & Solutions

### Error 1: "Connection refused"
```
SocketException: Connection refused
```

**Cause**: Server not accessible from Flutter

**Solutions**:

1. **Check server is running**:
   ```bash
   netstat -ano | findstr :5000
   ```
   Should show `LISTENING`

2. **Restart server**:
   ```bash
   python flask-model-server/app.py
   ```

3. **Check URL matches your platform**:
   - Android Emulator: `http://10.0.2.2:5000` ✅ (current)
   - iOS Simulator: `http://localhost:5000`
   - Physical Device: `http://YOUR_IP:5000`

### Error 2: "Request timeout"
```
TimeoutException after 30 seconds
```

**Cause**: Server too slow or not responding

**Solutions**:

1. **Check Flask terminal** for errors
2. **Restart server**
3. **Check models loaded**:
   ```
   ✓ Crop yield models loaded successfully
   ```

### Error 3: "Format exception"
```
FormatException: Unexpected character
```

**Cause**: Server returned error instead of JSON

**Solutions**:

1. **Check Flask terminal** for error messages
2. **Test API directly**:
   ```bash
   python test_yield_api.py
   ```

### Error 4: Using Physical Device

**If you're testing on a physical phone/tablet:**

1. **Find your computer's IP**:
   ```bash
   ipconfig  # Windows
   ```
   Look for "IPv4 Address" (e.g., 192.168.1.100)

2. **Update URL** in `lib/screens/crop_yield_prediction_screen.dart` line 87:
   ```dart
   Uri.parse('http://YOUR_IP:5000/predict_yield'),
   // Example: Uri.parse('http://192.168.1.100:5000/predict_yield'),
   ```

3. **Ensure same WiFi**: Phone and computer must be on same network

4. **Allow firewall**: Windows Firewall must allow Python

## 📱 Platform-Specific URLs

### Android Emulator (AVD)
```dart
Uri.parse('http://10.0.2.2:5000/predict_yield')
```
✅ This is what's currently set

### iOS Simulator
```dart
Uri.parse('http://localhost:5000/predict_yield')
```

### Physical Device
```dart
Uri.parse('http://192.168.1.100:5000/predict_yield')  // Use your IP
```

## 🧪 Debug Steps

### 1. Test Server Locally
```bash
python test_yield_api.py
```
Should show: `✅ SUCCESS!`

### 2. Test from Flutter
Tap the blue "Test Server Connection" button

### 3. Check Console Output
Look for error messages in Flutter console

### 4. Try Simple Prediction
Fill form with:
- State: Punjab
- Crop: Wheat
- Season: Rabi
- Area: 100
- Rainfall: 500
- Fertilizer: 5000
- Pesticide: 200
- Year: 2024

Tap "Predict Yield" and watch console

## 🔧 Quick Fixes

### Fix 1: Clear and Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

### Fix 2: Check Internet Permission

In `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android:permission.INTERNET"/>
```

### Fix 3: Disable SSL (if needed)

Add to `lib/screens/crop_yield_prediction_screen.dart`:
```dart
import 'dart:io';

// At the top of _predictYield():
HttpOverrides.global = MyHttpOverrides();

// Add this class:
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
```

## 📋 Verification Checklist

Before testing:
- [ ] Server running (`python flask-model-server/app.py`)
- [ ] No errors in Flask terminal
- [ ] API test works (`python test_yield_api.py`)
- [ ] Flutter hot restarted
- [ ] Using correct URL for platform
- [ ] Internet permission in manifest
- [ ] Firewall allows Python (if physical device)

## 🎯 Expected Behavior

### When Working Correctly:

1. **Tap "Test Server Connection"**
   - Shows "✅ Connected! Status: 200"

2. **Fill form and tap "Predict Yield"**
   - Button shows loading spinner (2-5 seconds)
   - Console shows:
     ```
     Making prediction request...
     Response status: 200
     Response body: {status: success, ...}
     ```
   - Results appear with predicted yield

### Console Output Example:
```
Making prediction request...
State: Punjab, Crop: Wheat, Season: Rabi
Response status: 200
Response body: {
  "status": "success",
  "predicted_yield": 17.42,
  "predicted_production": 1741.98,
  ...
}
```

## 🆘 Still Not Working?

### Get Detailed Error:

1. **Tap "Test Server Connection"** - What does it say?
2. **Check Flutter console** - Copy the exact error
3. **Check Flask terminal** - Any errors there?

### Most Common Issue:

**Wrong URL for your platform!**

- Are you using Android Emulator? → `http://10.0.2.2:5000` ✅
- Are you using iOS Simulator? → Change to `http://localhost:5000`
- Are you using Physical Device? → Change to `http://YOUR_IP:5000`

---

**After hot restart, tap the blue "Test Server Connection" button to diagnose the issue!** 🔍

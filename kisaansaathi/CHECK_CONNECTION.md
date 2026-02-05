# 🔍 Debug Flutter Connection Issue

## Current Status
✅ API is working (tested with Python)
❌ Flutter app can't connect

## Step-by-Step Debug

### 1. Check What You're Running On

**Are you using:**
- [ ] Android Emulator (AVD)
- [ ] iOS Simulator
- [ ] Physical Android Device
- [ ] Physical iOS Device
- [ ] Chrome/Web

### 2. Use Correct URL for Your Platform

#### Android Emulator (AVD)
```dart
Uri.parse('http://10.0.2.2:5000/predict_yield')
```
✅ This is what's currently in the code

#### iOS Simulator
```dart
Uri.parse('http://localhost:5000/predict_yield')
```

#### Physical Device (Android or iOS)
```dart
Uri.parse('http://YOUR_COMPUTER_IP:5000/predict_yield')
```

**Find your IP:**
```bash
# Windows
ipconfig
# Look for "IPv4 Address" under your active network

# Example: 192.168.1.100
```

### 3. Check Server is Accessible

**From your computer:**
```bash
# Should work
curl http://localhost:5000/predict_yield
```

**From Android Emulator:**
```bash
# In emulator terminal (adb shell)
curl http://10.0.2.2:5000/predict_yield
```

### 4. Check Flutter Console

When you tap "Predict Yield", check the Flutter console for:
```
Making prediction request...
State: Punjab, Crop: Wheat, Season: Rabi
```

Then look for errors like:
- `SocketException: Connection refused` → Server not accessible
- `TimeoutException` → Server too slow or not responding
- `FormatException` → Server returned invalid JSON

### 5. Quick Fixes

#### Fix 1: If using Physical Device

Update the URL in `lib/screens/crop_yield_prediction_screen.dart` line 84:

```dart
// Find your IP first
// Windows: ipconfig
// Mac/Linux: ifconfig

// Then update:
Uri.parse('http://YOUR_IP:5000/predict_yield'),
// Example: Uri.parse('http://192.168.1.100:5000/predict_yield'),
```

#### Fix 2: If using iOS Simulator

Update line 84:
```dart
Uri.parse('http://localhost:5000/predict_yield'),
```

#### Fix 3: Allow Firewall Access

**Windows Firewall:**
1. Search "Windows Defender Firewall"
2. Click "Allow an app through firewall"
3. Find Python
4. Check both Private and Public
5. Click OK

#### Fix 4: Test Connection from Device

**Android Emulator:**
```bash
# Open emulator terminal
adb shell

# Test connection
curl http://10.0.2.2:5000/predict_yield
```

### 6. Enable Internet Permission (Android)

Check `android/app/src/main/AndroidManifest.xml` has:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 7. Hot Restart Flutter

After any code changes:
```bash
# In Flutter console, press:
R  # Capital R for hot restart
```

Or:
```bash
flutter run
```

## 🎯 Most Common Issues

### Issue 1: Wrong URL for Platform
**Symptom**: Connection refused immediately

**Solution**: 
- Android Emulator → `http://10.0.2.2:5000`
- iOS Simulator → `http://localhost:5000`
- Physical Device → `http://YOUR_IP:5000`

### Issue 2: Server Not Running
**Symptom**: Connection refused after timeout

**Solution**:
```bash
python flask-model-server/app.py
```

### Issue 3: Firewall Blocking
**Symptom**: Works on computer, not on device

**Solution**: Allow Python through firewall

### Issue 4: Wrong Network
**Symptom**: Physical device can't connect

**Solution**: Ensure device and computer on same WiFi

## 🧪 Test Each Step

### Test 1: Server Running?
```bash
netstat -ano | findstr :5000
```
Should show: `LISTENING`

### Test 2: API Working?
```bash
python test_yield_api.py
```
Should show: `✅ SUCCESS!`

### Test 3: Flutter Can Reach Server?

Add this test button to your Flutter screen temporarily:

```dart
ElevatedButton(
  onPressed: () async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/'),
      );
      print('Connection test: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected! Status: ${response.statusCode}')),
      );
    } catch (e) {
      print('Connection test failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed: $e')),
      );
    }
  },
  child: Text('Test Connection'),
),
```

## 📱 Platform-Specific URLs

Create a helper function:

```dart
String getApiUrl() {
  // Check platform
  if (Platform.isAndroid) {
    // Check if emulator or physical device
    // For emulator:
    return 'http://10.0.2.2:5000';
    // For physical device:
    // return 'http://YOUR_IP:5000';
  } else if (Platform.isIOS) {
    return 'http://localhost:5000';
  }
  return 'http://localhost:5000';
}

// Then use:
Uri.parse('${getApiUrl()}/predict_yield')
```

## 🔧 Quick Fix Script

Create `fix_flutter_connection.dart`:

```dart
import 'dart:io';

void main() {
  print('Platform: ${Platform.operatingSystem}');
  print('Recommended URL:');
  
  if (Platform.isAndroid) {
    print('  Emulator: http://10.0.2.2:5000/predict_yield');
    print('  Device: http://YOUR_IP:5000/predict_yield');
  } else if (Platform.isIOS) {
    print('  Simulator: http://localhost:5000/predict_yield');
    print('  Device: http://YOUR_IP:5000/predict_yield');
  }
}
```

## 📋 Checklist

Before asking for help, verify:
- [ ] Server is running (`netstat -ano | findstr :5000`)
- [ ] API test works (`python test_yield_api.py`)
- [ ] Using correct URL for your platform
- [ ] Internet permission in AndroidManifest.xml
- [ ] Firewall allows Python
- [ ] Device and computer on same network (if physical device)
- [ ] Hot restarted Flutter after code changes

## 🆘 Still Not Working?

**Check Flutter console output when you tap "Predict Yield"**

Look for the error message and:
1. Copy the exact error
2. Check which line it fails on
3. The error will tell you exactly what's wrong

Common errors:
- `Connection refused` → Wrong URL or server not running
- `Timeout` → Server too slow or firewall blocking
- `Format exception` → Server returned error, check Flask logs

---

**Most likely issue**: Wrong URL for your platform. Update line 84 in `crop_yield_prediction_screen.dart` with the correct URL for your setup!

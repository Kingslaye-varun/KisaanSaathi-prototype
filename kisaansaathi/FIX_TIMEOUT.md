# 🔧 Fix TimeoutException - Server Connection Issue

## Problem
Flutter gets `TimeoutException` when trying to connect to the server.

## Root Cause
The URL `http://10.0.2.2:5000` only works for **Android Emulator**. If you're using something else, you need a different URL.

## ✅ Solution Based on Your Platform

### Are you using Android Emulator?

**If YES:**
The URL is correct, but the emulator can't reach your computer. Try this:

1. **Check server is running**:
   ```bash
   netstat -ano | findstr :5000
   ```
   Should show `LISTENING`

2. **Restart server with all interfaces**:
   The server should already be running on `0.0.0.0:5000` (all interfaces)

3. **Test from emulator**:
   ```bash
   adb shell
   curl http://10.0.2.2:5000
   ```

### Are you using iOS Simulator?

**Change the URL to:**
```dart
Uri.parse('http://localhost:5000/predict_yield')
```

### Are you using a Physical Device (Phone/Tablet)?

**You need your computer's IP address:**

1. **Find your IP**:
   ```bash
   ipconfig
   ```
   Look for "IPv4 Address" under your WiFi adapter
   Example: `192.168.1.100`

2. **Update the URL**:
   ```dart
   Uri.parse('http://192.168.1.100:5000/predict_yield')
   ```
   Replace `192.168.1.100` with YOUR actual IP

3. **Ensure same WiFi**: Device and computer must be on the same network

4. **Allow Firewall**:
   - Open Windows Defender Firewall
   - Allow Python through firewall
   - Check both Private and Public networks

### Are you using Chrome/Web?

**Change to:**
```dart
Uri.parse('http://localhost:5000/predict_yield')
```

## 🚀 Quick Fix Steps

### Step 1: Identify Your Platform

Run this in Flutter console:
```dart
print(Platform.operatingSystem);
```

Or check your run configuration in VS Code/Android Studio.

### Step 2: Update URL

Open `lib/screens/crop_yield_prediction_screen.dart`

Find line ~87 (in `_predictYield` function):
```dart
Uri.parse('http://10.0.2.2:5000/predict_yield'),
```

**Replace with the correct URL for your platform:**

**Android Emulator:**
```dart
Uri.parse('http://10.0.2.2:5000/predict_yield'),  // Keep as is
```

**iOS Simulator:**
```dart
Uri.parse('http://localhost:5000/predict_yield'),
```

**Physical Device:**
```dart
Uri.parse('http://YOUR_IP:5000/predict_yield'),  // Use your actual IP
```

### Step 3: Hot Restart

```bash
# Press R in Flutter console
R
```

### Step 4: Test Again

Tap "Test Server Connection" button

## 🔍 Detailed Fix for Physical Device

If you're using a **physical phone or tablet**:

### 1. Find Your Computer's IP

**Windows:**
```bash
ipconfig
```

Look for:
```
Wireless LAN adapter Wi-Fi:
   IPv4 Address. . . . . . . . . . . : 192.168.1.100
```

**Mac/Linux:**
```bash
ifconfig
```

### 2. Update Flutter Code

In `lib/screens/crop_yield_prediction_screen.dart`, line ~87:

```dart
// OLD (doesn't work for physical device):
Uri.parse('http://10.0.2.2:5000/predict_yield'),

// NEW (use your actual IP):
Uri.parse('http://192.168.1.100:5000/predict_yield'),
```

### 3. Check Same Network

**Computer and phone MUST be on the same WiFi network!**

### 4. Allow Firewall

**Windows:**
1. Search "Windows Defender Firewall"
2. Click "Allow an app or feature through Windows Defender Firewall"
3. Click "Change settings"
4. Find "Python" in the list
5. Check BOTH "Private" and "Public"
6. Click OK

**Test firewall:**
```bash
# From another computer on same network:
curl http://YOUR_IP:5000
```

### 5. Test from Phone Browser

Before testing in app, open phone browser and go to:
```
http://YOUR_IP:5000
```

Should see Flask welcome page or error (not timeout).

## 🧪 Test Each Step

### Test 1: Server Running?
```bash
netstat -ano | findstr :5000
```
✅ Should show: `LISTENING`

### Test 2: Server Accessible Locally?
```bash
curl http://localhost:5000
```
✅ Should return HTML or JSON

### Test 3: Server Accessible from Network?
```bash
# From another device on same WiFi:
curl http://YOUR_IP:5000
```
✅ Should return HTML or JSON

### Test 4: Flutter Can Connect?
Tap "Test Server Connection" button
✅ Should show "Connected!"

## 📝 Create Platform-Specific URL Helper

Add this to your Flutter code for automatic URL selection:

```dart
import 'dart:io';

String getApiBaseUrl() {
  if (Platform.isAndroid) {
    // Check if running on emulator or physical device
    // For now, assume emulator. Change if using physical device.
    return 'http://10.0.2.2:5000';
    
    // If using physical Android device, uncomment and add your IP:
    // return 'http://192.168.1.100:5000';
  } else if (Platform.isIOS) {
    // iOS Simulator
    return 'http://localhost:5000';
    
    // If using physical iOS device, uncomment and add your IP:
    // return 'http://192.168.1.100:5000';
  } else {
    // Web or other platforms
    return 'http://localhost:5000';
  }
}

// Then use it:
Uri.parse('${getApiBaseUrl()}/predict_yield')
```

## 🎯 Most Common Solutions

### Solution 1: Using iOS Simulator
Change line 87 to:
```dart
Uri.parse('http://localhost:5000/predict_yield'),
```

### Solution 2: Using Physical Device
1. Find your IP: `ipconfig`
2. Change line 87 to:
   ```dart
   Uri.parse('http://YOUR_IP:5000/predict_yield'),
   ```
3. Allow firewall
4. Ensure same WiFi

### Solution 3: Using Android Emulator (Current)
Should work as-is. If not:
1. Restart emulator
2. Restart server
3. Test with: `adb shell curl http://10.0.2.2:5000`

## 📱 Quick Platform Check

**To find out what you're using:**

1. Look at your Flutter run output:
   ```
   Launching lib/main.dart on Android SDK built for x86 in debug mode...
   ```
   - "Android SDK built for x86" = Android Emulator
   - "iPhone 14 Pro" = iOS Simulator
   - "SM-G991B" = Physical Android Device

2. Or check your IDE's device selector

## 🆘 Still Timing Out?

### Check These:

1. **Server logs**: Any errors in Flask terminal?
2. **Firewall**: Is Python allowed?
3. **Network**: Same WiFi for device and computer?
4. **URL**: Correct for your platform?
5. **Port**: Is 5000 actually listening?

### Get More Info:

Add this to see what's happening:
```dart
print('Attempting connection to: http://10.0.2.2:5000');
print('Platform: ${Platform.operatingSystem}');
```

---

**Most likely fix: Change the URL based on your platform!**

- Android Emulator → `http://10.0.2.2:5000` ✅
- iOS Simulator → `http://localhost:5000`
- Physical Device → `http://YOUR_IP:5000`

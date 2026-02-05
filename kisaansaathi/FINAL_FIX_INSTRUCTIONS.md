# 🎯 FINAL FIX: TimeoutException Solution

## What I Just Fixed

I've updated the code to automatically detect your platform and show you exactly what's wrong.

## 🚀 Do This Now:

### Step 1: Hot Restart Flutter
```bash
# In Flutter console, press:
R  # Capital R for hot restart
```

### Step 2: Test Connection
1. Open app
2. Go to "Yield Prediction"
3. **Tap "Test Server Connection"** (blue button)
4. Read the error message carefully

### Step 3: Follow the Solution

The error dialog will now show:
- Your platform (Android/iOS/Web)
- The URL it's trying to connect to
- Specific solutions for your platform

## 📱 Platform-Specific Fixes

### If You're Using Android Emulator:
✅ **URL is already correct**: `http://10.0.2.2:5000`

**If still timing out:**
1. Check server is running:
   ```bash
   netstat -ano | findstr :5000
   ```
2. Restart server:
   ```bash
   python flask-model-server/app.py
   ```
3. Restart emulator

### If You're Using iOS Simulator:
✅ **URL is already correct**: `http://localhost:5000`

**If still timing out:**
1. Check server is running
2. Restart server

### If You're Using Physical Device (Phone/Tablet):
❌ **You MUST change the URL to your computer's IP**

**Step-by-step:**

1. **Find your computer's IP**:
   ```bash
   ipconfig
   ```
   Look for "IPv4 Address" (e.g., `192.168.1.100`)

2. **Update the code**:
   
   Open `lib/screens/crop_yield_prediction_screen.dart`
   
   Find line ~25 (in the `apiUrl` getter):
   ```dart
   String get apiUrl {
     if (Platform.isAndroid) {
       // For physical Android device, uncomment this line:
       return 'http://192.168.1.100:5000';  // ← Use YOUR IP here
       
       // Comment out the emulator line:
       // return 'http://10.0.2.2:5000';
     }
     // ... rest of code
   }
   ```

3. **Do the same in** `lib/widgets/connection_test_button.dart` (line ~10)

4. **Ensure same WiFi**: Phone and computer on same network

5. **Allow firewall**:
   - Windows Defender Firewall
   - Allow Python
   - Check Private and Public

6. **Hot restart Flutter**

## 🧪 Verify Each Step

### ✅ Step 1: Server Running?
```bash
netstat -ano | findstr :5000
```
Should show: `LISTENING`

### ✅ Step 2: API Works Locally?
```bash
python test_yield_api.py
```
Should show: `✅ SUCCESS!`

### ✅ Step 3: Flutter Can Connect?
Tap "Test Server Connection"
Should show: `✅ Connected!`

### ✅ Step 4: Prediction Works?
Fill form and tap "Predict Yield"
Should show results in 2-5 seconds

## 🔍 What the Test Button Shows

### If Connection Succeeds:
```
✅ Connection Successful

Platform: android
URL: http://10.0.2.2:5000
Status Code: 200
Server is reachable!
```

### If Connection Fails:
```
❌ Connection Failed

Platform: android
Trying URL: http://10.0.2.2:5000
Error: TimeoutException after 5 seconds

Solutions:
[Platform-specific solutions listed]
```

## 📋 Quick Reference

| Platform | URL | Notes |
|----------|-----|-------|
| Android Emulator | `http://10.0.2.2:5000` | Already set ✅ |
| iOS Simulator | `http://localhost:5000` | Already set ✅ |
| Physical Device | `http://YOUR_IP:5000` | **Must change!** |
| Web | `http://localhost:5000` | Already set ✅ |

## 🎯 Most Common Issue

**Using a physical phone/tablet but URL is set for emulator!**

**Solution:**
1. Find your IP: `ipconfig`
2. Update `apiUrl` in both files
3. Allow firewall
4. Ensure same WiFi
5. Hot restart

## 🆘 Still Not Working?

### Check Console Output

After tapping "Test Server Connection", check Flutter console for:
```
Platform: android
API URL: http://10.0.2.2:5000/predict_yield
```

This tells you exactly what URL it's trying to use.

### Check Server Logs

Look at Flask terminal for any errors when you try to connect.

### Try Different URL

If emulator URL doesn't work, try localhost:
```dart
return 'http://localhost:5000';  // Try this
```

Or try your actual IP even for emulator:
```dart
return 'http://192.168.1.100:5000';  // Your IP
```

## ✅ Success Indicators

When everything works:

1. **Test button shows**: "✅ Connected! Status: 200"
2. **Console shows**: "Response status: 200"
3. **Prediction appears**: Within 2-5 seconds
4. **No timeout errors**

---

**After hot restart, the test button will tell you exactly what's wrong and how to fix it!** 🎯

**Most likely you need to change the URL if using a physical device!**

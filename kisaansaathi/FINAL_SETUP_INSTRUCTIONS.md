# Final Setup Instructions - Consumer Feature

## ✅ What's Fixed

1. **Backend Server** - Running on port 5000 with request logging
2. **API URL Configuration** - Updated to use your local network IP
3. **Consumer Routes** - Properly registered and tested

## 🚀 How to Run (Step by Step)

### Step 1: Verify Backend is Running

Check the backend terminal. You should see:
```
Server running on port 5000
MongoDB connected
```

If not running, start it:
```bash
cd backend
node server.js
```

### Step 2: Choose the Right API URL

Your `.env` file is now configured for **Physical Device** testing.

**If testing on Physical Device (current setup):**
```
NODE_API_URL=http://10.0.150.46:5000
```
✅ Already configured!

**If testing on Android Emulator:**
Uncomment this line in `.env`:
```
NODE_API_URL=http://10.0.2.2:5000
```

**If testing on iOS Simulator:**
Uncomment this line in `.env`:
```
NODE_API_URL=http://localhost:5000
```

### Step 3: Restart Flutter App

**IMPORTANT:** You must restart the app to load the new .env configuration.

1. Stop the current Flutter app (press 'q' in terminal)
2. Run again:
```bash
flutter run
```

### Step 4: Test Consumer Registration

1. App opens → Click "Sign up"
2. Select **"Consumer"** (right card with shopping bag icon)
3. Fill in:
   - Name: "Test Consumer"
   - Phone: "1234567890"
   - Language: English
   - Add a profile photo (click the camera icon)
4. Click "Continue"

### Step 5: Watch the Logs

**Backend Terminal:**
You should see:
```
2026-02-05T... - POST /api/consumers/register
```

**Flutter Terminal:**
You should see:
```
Registration successful!
```

## 🔍 Troubleshooting

### Issue 1: Still getting "HTML instead of JSON" error

**Solution A - Check Device Type:**
- Physical Device? Use `http://10.0.150.46:5000`
- Android Emulator? Use `http://10.0.2.2:5000`
- iOS Simulator? Use `http://localhost:5000`

**Solution B - Verify Backend is Accessible:**
From your device/emulator, try to access:
```
http://10.0.150.46:5000/api/consumers/test
```

If you can't reach it, check:
1. Firewall settings (allow port 5000)
2. Both device and computer are on same WiFi network
3. Computer's IP hasn't changed (run `ipconfig` again)

**Solution C - Hard-code the URL temporarily:**
Edit `lib/services/consumer_service.dart`:
```dart
static final String baseUrl = 'http://10.0.150.46:5000/api/consumers';
```

### Issue 2: "Network error" or "Connection refused"

**Check:**
1. Backend server is running
2. Port 5000 is not blocked by firewall
3. Device and computer are on same network

**Windows Firewall Fix:**
```powershell
netsh advfirewall firewall add rule name="Node.js Server" dir=in action=allow protocol=TCP localport=5000
```

### Issue 3: App crashes or freezes

**Solution:**
1. Clear app data:
```bash
flutter clean
flutter pub get
```

2. Restart:
```bash
flutter run
```

## 📱 Testing Checklist

After restarting the app, test these:

### Consumer Registration:
- [ ] Can select "Consumer" user type
- [ ] Can fill in name, phone, language
- [ ] Can upload profile photo
- [ ] Registration succeeds
- [ ] Navigates to Consumer Home (2 tabs)

### Consumer Home:
- [ ] See Community tab
- [ ] See Chats tab
- [ ] See floating chatbot button (bottom right)
- [ ] See profile menu (top right)
- [ ] NO Agri Store tab
- [ ] NO Home tab

### Consumer Features:
- [ ] Can view posts in Community
- [ ] Can create new post
- [ ] Can like/comment on posts
- [ ] Can open chatbot (floating button)
- [ ] Can close chatbot (X button)
- [ ] Can view profile (top right menu)
- [ ] Can logout

### Farmer Registration (for comparison):
- [ ] Can select "Farmer" user type
- [ ] Can fill in name, phone, language, Farmer ID
- [ ] Registration succeeds
- [ ] Navigates to Farmer Home (4 tabs)

## 🎯 Expected Behavior

### When you register as Consumer:

**Backend logs:**
```
2026-02-05T13:45:23.456Z - POST /api/consumers/register
```

**Flutter logs:**
```
Registration successful!
```

**Screen:**
```
┌─────────────────────────────────────┐
│  Community              [Profile 👤]│
├─────────────────────────────────────┤
│                                     │
│  [Community posts feed]             │
│                                     │
│                          [💬 Chat]  │ ← Floating button
└─────────────────────────────────────┘
│ 👥 Community  │  💬 Chats  │
└─────────────────────────────────────┘
```

## 🔧 Quick Fixes

### Fix 1: Update API URL for your device type
```bash
# Edit .env file
# Uncomment the line for your device type
```

### Fix 2: Restart Flutter app
```bash
# Press 'q' to quit
flutter run
```

### Fix 3: Check backend logs
```bash
# Should see requests coming in
# If not, check firewall/network
```

### Fix 4: Test backend directly
```bash
curl http://10.0.150.46:5000/api/consumers/test
# Should return JSON (even if error)
```

## 📊 Current Configuration

**Backend:**
- ✅ Running on port 5000
- ✅ MongoDB connected
- ✅ Consumer routes registered
- ✅ Request logging enabled

**Frontend:**
- ✅ Consumer service created
- ✅ Login screen updated
- ✅ Signup screen updated
- ✅ Consumer home screen created
- ✅ Routing configured

**API URL:**
- ✅ Set to `http://10.0.150.46:5000` (Physical Device)
- ⚠️ Change if using emulator/simulator

## 🎉 Success Criteria

You'll know it's working when:
1. ✅ Backend logs show: `POST /api/consumers/register`
2. ✅ Flutter shows: "Registration successful!"
3. ✅ App navigates to Consumer Home with 2 tabs
4. ✅ Floating chatbot button appears
5. ✅ Profile menu shows "Consumer" badge

## 📞 Still Having Issues?

1. **Check backend logs** - Are requests reaching the server?
2. **Check Flutter logs** - What's the exact error message?
3. **Test backend directly** - Can you curl the endpoint?
4. **Verify network** - Are device and computer on same WiFi?
5. **Check firewall** - Is port 5000 allowed?

---

**Current Status:**
- ✅ Backend: Running
- ✅ MongoDB: Connected
- ✅ API URL: Configured for Physical Device
- ⚠️ Flutter: Needs restart to load new .env

**Next Step:** 
1. Stop Flutter app (press 'q')
2. Run `flutter run`
3. Try consumer registration again

**Your Computer's IP:** 10.0.150.46
**Backend Port:** 5000
**Full API URL:** http://10.0.150.46:5000

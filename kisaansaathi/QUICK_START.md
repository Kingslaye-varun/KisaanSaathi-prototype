# Quick Start Guide - Consumer Feature

## ✅ What's Done

1. **Backend Server** - Running on port 5000 ✅
2. **Consumer Model** - Created ✅
3. **Consumer Routes** - Implemented ✅
4. **Consumer Service** - Created ✅
5. **Login Screen** - Updated with user type selection ✅
6. **Signup Screen** - Updated with user type support ✅
7. **Consumer Home** - Created with limited features ✅
8. **Routing** - Updated to support both user types ✅

## 🚀 How to Test Right Now

### Step 1: Run the Flutter App
```bash
flutter run
```

### Step 2: Test Consumer Registration
1. App opens → Click "Sign up"
2. Select **"Consumer"** (right card with shopping bag icon)
3. Fill in:
   - Name: "John Consumer"
   - Phone: "1234567890"
   - Language: English
   - Add a profile photo
4. Click "Continue"

**Expected:** Navigate to Consumer Home with 2 tabs (Community, Chats) and a floating chatbot button

### Step 3: Test Consumer Features
1. **Community Tab:**
   - View posts from farmers
   - Create your own post
   - Like/comment on posts

2. **Chatbot:**
   - Click green floating button (bottom right)
   - Ask: "What vegetables are available?"
   - Close with X button

3. **Profile:**
   - Click profile icon (top right)
   - View profile info
   - Logout

### Step 4: Test Farmer Registration
1. Logout from consumer account
2. Click "Sign up"
3. Select **"Farmer"** (left card with agriculture icon)
4. Fill in:
   - Name: "Jane Farmer"
   - Phone: "0987654321"
   - Language: English
   - Add a profile photo
   - Farmer ID: Leave empty or enter "KL123456789012"
5. Click "Continue"

**Expected:** Navigate to Farmer Home with 4 tabs (Home, Community, Agri Store, Profile)

### Step 5: Test Login
1. Logout
2. On login screen, select **"Consumer"**
3. Enter phone: "1234567890"
4. Click "Login"

**Expected:** Login successful, navigate to Consumer Home

## 🎯 Key Features to Test

### Consumer Features:
- ✅ Can register with phone number
- ✅ Can login as consumer
- ✅ See only Community and Chats tabs
- ✅ Floating chatbot button (bottom right)
- ✅ Profile menu (top right)
- ✅ Can post in community
- ✅ Can chat with farmers
- ✅ Cannot access Agri Store
- ✅ Cannot access Home screen

### Farmer Features (Unchanged):
- ✅ Can register with phone number and optional Farmer ID
- ✅ Can login as farmer
- ✅ See all 4 tabs (Home, Community, Agri Store, Profile)
- ✅ Full access to all features

## 📱 UI Differences

### Login Screen:
```
┌─────────────────────────────────────┐
│  I am a:                            │
│  ┌──────────┐    ┌──────────┐      │
│  │ 🌾 Farmer│    │ 🛍️ Consumer│     │
│  │  Sell &  │    │   Buy     │      │
│  │  Trade   │    │  Fresh    │      │
│  └──────────┘    └──────────┘      │
│                                     │
│  Phone Number: [+91 __________]    │
│  Language: [English ▼]             │
│  [Login Button]                    │
└─────────────────────────────────────┘
```

### Consumer Home:
```
┌─────────────────────────────────────┐
│  Community              [Profile 👤]│
├─────────────────────────────────────┤
│                                     │
│  [Posts from farmers and consumers] │
│                                     │
│                                     │
│                          [💬 Chat]  │ ← Floating button
└─────────────────────────────────────┘
│ 👥 Community  │  💬 Chats  │
└─────────────────────────────────────┘
```

### Farmer Home (Unchanged):
```
┌─────────────────────────────────────┐
│  Home                               │
├─────────────────────────────────────┤
│                                     │
│  [All farmer features]              │
│                                     │
└─────────────────────────────────────┘
│ 🏠 Home │ 👥 Community │ 🛒 Store │ 👤 Profile │
└─────────────────────────────────────┘
```

## 🐛 Troubleshooting

### Issue: "Server returned HTML instead of JSON"
**Solution:** Backend is not running. Check if server is running on port 5000.

### Issue: Login redirects to wrong screen
**Solution:** Clear app data and try again:
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Chatbot not appearing
**Solution:** Make sure you're logged in as Consumer. Farmers access chatbot via route, not floating button.

### Issue: Can't upload profile image
**Solution:** Grant camera/gallery permissions when prompted.

## 📊 Test Data

Use these phone numbers for testing:

| User Type | Phone Number | Name |
|-----------|--------------|------|
| Consumer 1 | 1234567890 | John Consumer |
| Consumer 2 | 1111111111 | Jane Consumer |
| Farmer 1 | 0987654321 | Bob Farmer |
| Farmer 2 | 2222222222 | Alice Farmer |

## ✅ Success Criteria

After testing, you should be able to:
- [ ] Register as Consumer
- [ ] Register as Farmer
- [ ] Login as Consumer → See 2 tabs
- [ ] Login as Farmer → See 4 tabs
- [ ] Consumer can use chatbot (floating button)
- [ ] Consumer can post in community
- [ ] Consumer can chat with farmers
- [ ] Consumer cannot access Agri Store
- [ ] Logout and re-login works
- [ ] App remembers user type after restart

## 📝 Next Steps

1. **Run the app:** `flutter run`
2. **Follow the test steps above**
3. **Report any issues you find**
4. **If everything works:** Ready for production! 🎉

## 🆘 Need Help?

Check these files:
- `CONSUMER_FEATURE_TESTING.md` - Detailed testing guide
- `IMPLEMENTATION_SUMMARY.md` - Technical details
- Backend logs - Check terminal where `node server.js` is running
- Flutter logs - Check terminal where `flutter run` is running

---

**Backend Status:** ✅ Running (Port 5000)
**MongoDB Status:** ✅ Connected
**Ready to Test:** ✅ Yes

**Just run:** `flutter run` and start testing! 🚀

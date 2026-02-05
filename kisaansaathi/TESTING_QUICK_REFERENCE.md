# Worker Module - Quick Testing Reference

## 🚀 Quick Start

### 1. Start Backend
```bash
cd kisaansaathi/backend
npm start
```
✅ Server should start on port 5000

### 2. Run Flutter App
```bash
cd kisaansaathi
flutter run
```
✅ App should launch on emulator/device

---

## 👤 Test User Credentials

### Farmer
- **Phone:** 1234567890
- **Name:** Test Farmer
- **Role:** Can post jobs

### Worker
- **Phone:** 9876543210
- **Name:** Test Worker
- **Role:** Can accept jobs

### Consumer
- **Phone:** 5555555555
- **Name:** Test Consumer
- **Role:** Can buy products

---

## 🧪 Test Scenarios

### Scenario 1: Worker Registration ✅
1. Open app → Select "Worker" → Sign up
2. Enter: Name, Phone (9876543210), Upload photo
3. Click "Continue"
4. **Expected:** Redirected to Worker Home Screen

### Scenario 2: Farmer Posts Job ✅
1. Login as Farmer → Click "Hire Worker"
2. Select: Harvesting, ₹500, "Need help with rice"
3. Click "Post Job"
4. **Expected:** Job appears in "My Posted Jobs"

### Scenario 3: Worker Accepts Job ✅
1. Login as Worker → "Available Jobs" tab
2. See job → Click "Accept Job" → Confirm
3. **Expected:** Job moves to "My Jobs" tab

### Scenario 4: Call Farmer ✅
1. Worker Home → Click "Call Farmer"
2. **Expected:** Phone dialer opens with number

### Scenario 5: Delete Job ✅
1. Farmer → "Hire Worker" → Find pending job
2. Click "Delete" → Confirm
3. **Expected:** Job removed from list

---

## 🎯 Quick Verification Points

### Worker Side
- [ ] Can register with/without image
- [ ] Sees all available jobs
- [ ] Can call farmer
- [ ] Can accept jobs
- [ ] Accepted jobs in "My Jobs"

### Farmer Side
- [ ] "Hire Worker" button visible
- [ ] Can post jobs
- [ ] Sees job status
- [ ] Sees worker name when accepted
- [ ] Can delete pending jobs

---

## 🐛 Common Issues & Quick Fixes

### Issue: PathNotFoundException
**Fix:** Already fixed! Uses multipart upload now.

### Issue: Jobs not showing
**Fix:** Pull-to-refresh or check backend is running

### Issue: Can't call farmer
**Fix:** Test on physical device (not emulator)

### Issue: Image not uploading
**Fix:** Check Cloudinary config, but registration still works

---

## 📱 Screen Navigation

```
Login Screen
├─ Farmer → Farmer Home → Hire Worker
├─ Consumer → Consumer Home
└─ Worker → Worker Home
    ├─ Available Jobs Tab
    └─ My Jobs Tab
```

---

## 🔍 Backend Verification

### Check MongoDB Collections
```javascript
// In MongoDB shell or Compass
db.workers.find()
db.workrequests.find()
```

### Check API Endpoints
```bash
# Get open jobs
curl http://localhost:5000/api/work-requests/open

# Get worker by phone
curl http://localhost:5000/api/workers/phone/9876543210
```

---

## ✅ Success Checklist

- [ ] Backend running on port 5000
- [ ] MongoDB connected
- [ ] Worker can register
- [ ] Farmer can post jobs
- [ ] Worker can see jobs
- [ ] Worker can accept jobs
- [ ] Farmer sees status updates
- [ ] No crashes or errors

---

## 📞 Test Phone Numbers

Use these for testing:
- **Farmer:** 1234567890
- **Worker 1:** 9876543210
- **Worker 2:** 9876543211
- **Consumer:** 5555555555

---

## 🎨 UI Elements to Check

### Worker Home Screen
- ✅ AppBar with title and refresh button
- ✅ Bottom navigation (2 tabs)
- ✅ Job cards with work type, payment, description
- ✅ "Call Farmer" and "Accept Job" buttons

### Hire Worker Screen
- ✅ Job posting form
- ✅ Work type dropdown
- ✅ Payment input field
- ✅ Description text area
- ✅ "Post Job" button
- ✅ "My Posted Jobs" list

### Farmer Home Screen
- ✅ "Hire Worker" card (indigo, work icon)
- ✅ Located in grid with other features

---

## 🔄 Quick Reset

If you need to start fresh:

```bash
# Clear app data
flutter clean
flutter pub get
flutter run

# Or on device
Settings → Apps → KisaanSaathi → Clear Data
```

---

## 📊 Expected Data Flow

1. **Farmer posts job** → MongoDB (status: Pending)
2. **Worker sees job** → Fetches from MongoDB
3. **Worker accepts** → Updates MongoDB (status: Accepted)
4. **Farmer refreshes** → Sees updated status

---

## 🎉 All Tests Pass?

If everything works:
- ✅ Worker module is fully functional
- ✅ Ready for production testing
- ✅ Can proceed with user acceptance testing

---

**Happy Testing! 🌾**

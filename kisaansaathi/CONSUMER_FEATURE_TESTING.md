# Consumer Feature Testing Guide

## Overview
This document outlines the complete testing procedure for the new Consumer stakeholder feature in KisaanSaathi app.

## What's New

### 1. **Two User Types**
- **Farmer**: Full access to all features (Home, Community, Agri Store, Profile)
- **Consumer**: Limited access (Community, Chat, Chatbot only)

### 2. **Backend Changes**
- New Consumer model (`backend/models/Consumer.js`)
- New Consumer routes (`backend/routes/consumers.js`)
- Updated server.js to include consumer routes

### 3. **Frontend Changes**
- New Consumer Service (`lib/services/consumer_service.dart`)
- New Consumer Model (`lib/models/consumer.dart`)
- Updated Login Screen with user type selection
- Updated Signup Screen with user type support
- New Consumer Home Screen with limited features
- Updated main.dart with consumer routing

## Testing Steps

### Step 1: Start Backend Server
```bash
cd backend
node server.js
```
**Expected Output:**
```
Server running on port 5000
MongoDB connected
```

### Step 2: Clean App Data (Fresh Start)
```bash
flutter clean
flutter pub get
```

### Step 3: Run the App
```bash
flutter run
```

### Step 4: Test Farmer Registration & Login

#### 4.1 Register as Farmer
1. Open the app
2. Click "Sign up"
3. Select **"Farmer"** user type (should be selected by default)
4. Fill in:
   - Name: "Test Farmer"
   - Phone: "9876543210"
   - Language: Select any
   - Profile Image: Add a photo
   - Farmer ID (Optional): Leave empty or enter "KL123456789012"
5. Click "Continue"

**Expected Result:**
- Success message: "Registration successful!"
- Navigate to Farmer Home Screen with 4 tabs: Home, Community, Agri Store, Profile

#### 4.2 Logout and Login as Farmer
1. Go to Profile tab
2. Click Logout
3. On Login screen, select **"Farmer"** user type
4. Enter phone: "9876543210"
5. Click "Login"

**Expected Result:**
- Success message: "Login successful!"
- Navigate to Farmer Home Screen

### Step 5: Test Consumer Registration & Login

#### 5.1 Register as Consumer
1. Logout from farmer account
2. Click "Sign up"
3. Select **"Consumer"** user type
4. Fill in:
   - Name: "Test Consumer"
   - Phone: "9876543211"
   - Language: Select any
   - Profile Image: Add a photo
   - (Note: No Farmer ID field for consumers)
5. Click "Continue"

**Expected Result:**
- Success message: "Registration successful!"
- Navigate to Consumer Home Screen with only 2 tabs: Community, Chats

#### 5.2 Test Consumer Features

**Community Tab:**
- Should see all posts from farmers
- Can create new posts
- Can like/comment on posts
- Can view farmer profiles

**Chats Tab:**
- Should see list of conversations
- Can chat with farmers

**Chatbot (Floating Button):**
- Click the green floating chat button (bottom right)
- Chatbot overlay should appear
- Can ask questions to AI assistant
- Click X to close chatbot

**Profile Menu:**
- Click profile icon in top right
- Should show:
  - Profile picture
  - Name
  - "Consumer" badge
  - Logout option

#### 5.3 Logout and Login as Consumer
1. Click profile icon → Logout
2. On Login screen, select **"Consumer"** user type
3. Enter phone: "9876543211"
4. Click "Login"

**Expected Result:**
- Success message: "Login successful!"
- Navigate to Consumer Home Screen (not Farmer Home)

### Step 6: Test User Type Persistence

#### 6.1 Close and Reopen App
1. Close the app completely
2. Reopen the app

**Expected Result:**
- Should automatically login to the last logged-in account
- If it was Consumer, should go to Consumer Home
- If it was Farmer, should go to Farmer Home

### Step 7: Test Edge Cases

#### 7.1 Wrong User Type Login
1. Register as Farmer with phone "1111111111"
2. Logout
3. Try to login as **Consumer** with phone "1111111111"

**Expected Result:**
- Error message: "Consumer not found. Please register."
- Should redirect to Consumer signup

#### 7.2 Switch Between User Types
1. Login as Farmer
2. Logout
3. Login as Consumer
4. Logout
5. Login as Farmer again

**Expected Result:**
- Each login should navigate to the correct home screen
- No data mixing between user types

### Step 8: Test Chatbot Integration

#### 8.1 Consumer Chatbot
1. Login as Consumer
2. Click floating chat button
3. Ask: "What crops can I buy?"
4. Verify response
5. Close chatbot
6. Switch to Chats tab
7. Chatbot should close automatically

**Expected Result:**
- Chatbot opens/closes smoothly
- No UI glitches
- Chatbot closes when switching tabs

### Step 9: Test Community Features

#### 9.1 Consumer Posting
1. Login as Consumer
2. Go to Community tab
3. Click "+" button to create post
4. Add text and image
5. Post it

**Expected Result:**
- Post should be created successfully
- Should appear in community feed
- Other users (farmers/consumers) should see it

#### 9.2 Consumer Interaction
1. As Consumer, like a farmer's post
2. Comment on a farmer's post
3. Click on farmer's profile

**Expected Result:**
- All interactions should work
- Can view farmer profiles
- Can see farmer's posts

### Step 10: Test Chat Features

#### 10.1 Consumer-Farmer Chat
1. Login as Consumer
2. Go to Community
3. Click on a farmer's post
4. Click "Chat" button
5. Send a message

**Expected Result:**
- Chat screen opens
- Can send/receive messages
- Messages are saved

## Common Issues & Solutions

### Issue 1: "Server returned HTML instead of JSON"
**Solution:** 
- Check if backend server is running
- Verify .env file has correct MONGODB_URI and NODE_API_URL

### Issue 2: Login redirects to wrong home screen
**Solution:**
- Clear app data: `flutter clean`
- Check SharedPreferences: userType should be 'farmer' or 'consumer'

### Issue 3: Chatbot not appearing
**Solution:**
- Check if FloatingActionButton is visible
- Verify _showChatbot state is toggling correctly

### Issue 4: Profile image not uploading
**Solution:**
- Check camera/gallery permissions
- Verify Cloudinary credentials in backend .env

### Issue 5: Consumer can see farmer-only features
**Solution:**
- Verify routing in main.dart
- Check userType in SharedPreferences

## Backend API Endpoints

### Consumer Endpoints
- `POST /api/consumers/register` - Register new consumer
- `GET /api/consumers/:phoneNumber` - Get consumer by phone
- `PUT /api/consumers/:phoneNumber` - Update consumer profile

### Farmer Endpoints (Existing)
- `POST /api/farmers/register` - Register new farmer
- `GET /api/farmers/:phoneNumber` - Get farmer by phone
- `PUT /api/farmers/:phoneNumber` - Update farmer profile

## Database Collections

### Consumers Collection
```json
{
  "_id": "ObjectId",
  "name": "String",
  "phoneNumber": "String (unique)",
  "language": "String",
  "profileImage": {
    "url": "String",
    "publicId": "String"
  },
  "createdAt": "Date",
  "updatedAt": "Date"
}
```

### Farmers Collection (Existing)
```json
{
  "_id": "ObjectId",
  "name": "String",
  "phoneNumber": "String (unique)",
  "language": "String",
  "farmerId": "String (optional)",
  "profileImage": {
    "url": "String",
    "publicId": "String"
  },
  "createdAt": "Date",
  "updatedAt": "Date"
}
```

## Success Criteria

✅ Farmers can register and access all features
✅ Consumers can register and access limited features (Community, Chat, Chatbot)
✅ User type selection works on login/signup
✅ Correct home screen loads based on user type
✅ Chatbot appears as floating button for consumers
✅ Consumer profile shows "Consumer" badge
✅ No data mixing between user types
✅ Logout and re-login works correctly
✅ App remembers user type after restart

## Next Steps After Testing

1. **If all tests pass:**
   - Deploy backend to production
   - Test on physical devices
   - Gather user feedback

2. **If tests fail:**
   - Check error logs
   - Verify backend connectivity
   - Review SharedPreferences data
   - Check routing logic

## Support

If you encounter any issues during testing:
1. Check backend logs: `backend/server.js` console output
2. Check Flutter logs: Run with `flutter run --verbose`
3. Verify MongoDB connection
4. Check .env files in both backend and root directory

---

**Last Updated:** February 5, 2026
**Version:** 1.0.0
**Author:** Kiro AI Assistant

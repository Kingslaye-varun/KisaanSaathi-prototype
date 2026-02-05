# Quick Test Guide - Chat & Language Features

## 🚀 Quick Start

### Prerequisites
1. Backend server running at: `https://kisaansaathi-backend-sq7f.onrender.com`
2. `.env` file configured with `NODE_API_URL`
3. App installed on device/emulator

---

## 📱 Testing Chat System

### Test 1: Farmer to Farmer Chat
1. **Login as Farmer A**
2. Go to **Community** tab (bottom navigation)
3. Find any post by another farmer
4. Click the **green message icon** on the post card
5. Chat screen opens with that farmer's name in header
6. Type a message: "Hello, I saw your post about tomatoes"
7. Click send button
8. ✅ Message appears in green bubble on right side

### Test 2: Consumer to Farmer Chat
1. **Login as Consumer**
2. You're on **Community screen** (main screen)
3. Find any farmer's post
4. Click the **green message icon** on the post
5. Chat screen opens
6. Type: "Hi, I'm interested in buying your vegetables"
7. Click send
8. ✅ Message sent successfully

### Test 3: View All Conversations (Consumer)
1. **As Consumer**, click **chat icon** in top app bar
2. See list of all conversations
3. Each shows:
   - Farmer's name
   - Last message preview
   - Time
   - Unread count (if any)
4. Click any conversation to open chat
5. ✅ Chat history loads

### Test 4: Two-Way Communication
1. **Login as Farmer A** on Device 1
2. **Login as Farmer B** on Device 2
3. Farmer A: Go to community, click message on Farmer B's post
4. Farmer A: Send message "Hello"
5. **Wait 3 seconds** (polling interval)
6. Farmer B: Open chat list or check existing chat
7. ✅ Farmer B sees Farmer A's message
8. Farmer B: Reply "Hi there!"
9. **Wait 3 seconds**
10. ✅ Farmer A sees reply

---

## 🌍 Testing Language Switcher

### Test 1: Change Language (Farmer)
1. **Login as Farmer**
2. On home screen, look at top right
3. Click **globe icon** (🌐) next to notifications
4. Bottom sheet opens with language list
5. Select **Hindi** (हिंदी)
6. ✅ Green confirmation message appears
7. ✅ App text changes to Hindi immediately

### Test 2: Change Language (Consumer)
1. **Login as Consumer**
2. On home screen (Community), look at top right
3. Click **globe icon** (🌐) before chat icon
4. Select **Malayalam** (മലയാളം)
5. ✅ App changes to Malayalam
6. Navigate to different screens
7. ✅ All screens show Malayalam text

### Test 3: Language Persistence
1. Change language to **Tamil**
2. ✅ Confirmation appears
3. **Close app completely** (swipe away from recent apps)
4. **Reopen app**
5. ✅ App still in Tamil
6. Change back to **English**
7. ✅ Works perfectly

### Test 4: Try All Languages
Test each language by selecting from the list:
- 🇬🇧 English
- 🇮🇳 Malayalam (മലയാളം)
- 🇮🇳 Hindi (हिंदी)
- 🇮🇳 Punjabi (ਪੰਜਾਬੀ)
- 🇮🇳 Bengali (বাংলা)
- 🇮🇳 Tamil (தமிழ்)
- 🇮🇳 Telugu (తెలుగు)
- 🇮🇳 Marathi (मराठी)
- 🇮🇳 Gujarati (ગુજરાતી)
- 🇮🇳 Kannada (ಕನ್ನಡ)

---

## 🔍 What to Look For

### Chat System Success Indicators
✅ Message icon visible on all community posts
✅ Clicking message icon opens chat screen
✅ Chat screen shows other user's name and profile
✅ Can type and send messages
✅ Messages appear in bubbles (green for sent, gray for received)
✅ Timestamps show on messages
✅ New messages appear after 3 seconds
✅ Chat list shows all conversations
✅ Unread count displays correctly

### Language Switcher Success Indicators
✅ Globe icon visible in app bar
✅ Clicking opens language selection sheet
✅ All 10 languages listed with flags
✅ Selecting language changes app immediately
✅ Confirmation message appears
✅ Language persists after app restart
✅ All screens update to new language

---

## ❌ Common Issues & Solutions

### Issue: Chat not opening
**Solution:** 
- Check if backend is running
- Verify `.env` has correct URL
- Check console logs for errors

### Issue: Messages not appearing
**Solution:**
- Wait 3 seconds for polling
- Check network connection
- Refresh chat screen

### Issue: Language not changing
**Solution:**
- Check if screen uses AppLocalizations
- Restart app
- Clear app data and try again

### Issue: "No conversations yet" message
**Solution:**
- This is normal for new users
- Start a chat from community post first
- Then check chat list

---

## 📊 Expected Behavior

### Chat Flow
```
User A clicks message icon on User B's post
    ↓
Chat screen opens with User B's details
    ↓
User A sends message
    ↓
Message saved to backend
    ↓
User B's app polls backend (every 3 seconds)
    ↓
User B sees message
    ↓
User B replies
    ↓
User A sees reply (after 3 seconds)
```

### Language Flow
```
User clicks globe icon
    ↓
Language list appears
    ↓
User selects language
    ↓
Saved to SharedPreferences
    ↓
App locale updates
    ↓
All screens refresh with new language
    ↓
Confirmation message shows
```

---

## 🎯 Success Criteria

### Chat System
- [x] Can initiate chat from community posts
- [x] Messages send successfully
- [x] Messages appear in real-time (3s delay)
- [x] Chat history persists
- [x] Two-way communication works
- [x] Profile images display correctly
- [x] Timestamps are accurate

### Language Switcher
- [x] Globe icon visible on home screens
- [x] All 10 languages selectable
- [x] Language changes immediately
- [x] Language persists after restart
- [x] Confirmation feedback provided
- [x] Works for both farmers and consumers

---

## 📝 Test Checklist

### Before Testing
- [ ] Backend server is running
- [ ] `.env` file configured
- [ ] App installed on device
- [ ] At least 2 test accounts available

### Chat Tests
- [ ] Farmer to Farmer chat works
- [ ] Consumer to Farmer chat works
- [ ] Messages send successfully
- [ ] Messages receive successfully
- [ ] Chat list shows conversations
- [ ] Unread counts display
- [ ] Profile images load
- [ ] Timestamps are correct

### Language Tests
- [ ] Globe icon visible
- [ ] Language sheet opens
- [ ] Can select each language
- [ ] App updates immediately
- [ ] Language persists
- [ ] Confirmation shows
- [ ] Works on all screens

---

## 🎉 You're Done!

If all tests pass, both features are working perfectly! 

**Next Steps:**
- Test with real users
- Monitor backend logs
- Collect feedback
- Plan enhancements (WebSocket, push notifications, etc.)

---

## 📞 Need Help?

Check the detailed documentation in `CHAT_AND_LANGUAGE_IMPLEMENTATION.md` for:
- Architecture details
- API endpoints
- Code structure
- Troubleshooting guide
- Future enhancements

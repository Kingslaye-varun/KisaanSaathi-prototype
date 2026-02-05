# Consumer UI Update - Testing Guide

## 🎨 What's New

### 1. **Redesigned Consumer Home**
- ✅ Community screen is now the main home (no tabs)
- ✅ Removed back button
- ✅ Added chat icon in app bar (top right)
- ✅ Added profile icon in app bar (top right)
- ✅ Floating chatbot button (bottom right)

### 2. **New Consumer Profile Page**
- ✅ Beautiful gradient header
- ✅ Profile image display
- ✅ Consumer badge
- ✅ Phone number, language, account type cards
- ✅ Logout button

### 3. **WhatsApp-Style Chat System**
- ✅ Chat list screen showing all conversations
- ✅ Individual chat detail screen
- ✅ Real-time message polling (every 3 seconds)
- ✅ Unread message badges
- ✅ Message timestamps
- ✅ WhatsApp-like message bubbles

### 4. **Backend Chat System**
- ✅ Message model with sender/receiver
- ✅ Chat routes (conversations, messages, send)
- ✅ Support for Farmer-Consumer and Farmer-Farmer chats
- ✅ Unread message tracking
- ✅ Automatic read receipts

## 🚀 How to Test

### Step 1: Start Backend
```bash
cd backend
node server.js
```

**Expected Output:**
```
Server running on port 5000
MongoDB connected
```

### Step 2: Run Flutter App
```bash
flutter run
```

### Step 3: Register as Consumer
1. Click "Sign up"
2. Select "Consumer"
3. Fill details:
   - Name: "Test Consumer"
   - Phone: "1234567890"
   - Add profile photo
4. Click "Continue"

**Expected:**
- Navigate to Community screen (no tabs)
- See chat icon (top right)
- See profile icon (top right)
- See floating chatbot button (bottom right)

### Step 4: Test Profile
1. Click profile icon (top right)
2. Should see:
   - Profile image
   - Name
   - "Consumer" badge
   - Phone number card
   - Language card
   - Account type card
   - Logout button

### Step 5: Test Chatbot
1. Click floating chatbot button (bottom right)
2. Chatbot overlay should appear
3. Ask a question
4. Click X to close

### Step 6: Test Chat List
1. Click chat icon (top right)
2. Should see "No conversations yet" message
3. Go back to community
4. Find a farmer's post
5. Click on farmer's profile
6. Click "Chat" button

**Expected:**
- Opens chat detail screen
- Can send messages
- Messages appear in WhatsApp-style bubbles
- Your messages on right (green)
- Their messages on left (grey)

### Step 7: Test Real-Time Chat
1. Open chat with a farmer
2. Send a message: "Hello!"
3. Wait 3 seconds
4. Messages should auto-refresh
5. Go back to chat list
6. Should see the conversation with last message

### Step 8: Register as Farmer (for testing chat)
1. Logout from consumer
2. Register as farmer:
   - Name: "Test Farmer"
   - Phone: "0987654321"
3. Go to community
4. Find consumer's post
5. Click "Chat" button
6. Send message to consumer

### Step 9: Test Consumer Receiving Messages
1. Logout from farmer
2. Login as consumer (phone: 1234567890)
3. Click chat icon
4. Should see conversation with farmer
5. Should show unread badge if farmer sent messages
6. Click on conversation
7. Should see farmer's messages

## 📱 UI Screenshots

### Consumer Home Screen:
```
┌─────────────────────────────────────┐
│  Community        💬  👤            │ ← Chat & Profile icons
├─────────────────────────────────────┤
│                                     │
│  [Community Posts Feed]             │
│  - View posts                       │
│  - Create posts                     │
│  - Like/Comment                     │
│                                     │
│                          [🤖]       │ ← Floating chatbot
└─────────────────────────────────────┘
```

### Chat List Screen:
```
┌─────────────────────────────────────┐
│  ← Chats                    🔄      │
├─────────────────────────────────────┤
│  👤 Test Farmer              12:30  │
│     Hello! How can I help?    [2]  │ ← Unread badge
├─────────────────────────────────────┤
│  👤 Another Farmer           11:15  │
│     Thanks for the info!           │
├─────────────────────────────────────┤
│  👤 Farmer 3                 10:00  │
│     See you tomorrow!              │
└─────────────────────────────────────┘
```

### Chat Detail Screen:
```
┌─────────────────────────────────────┐
│  ← 👤 Test Farmer                   │
│     Farmer                          │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────┐                │ ← Their message
│  │ Hello! How are  │                │
│  │ you?            │                │
│  │           12:30 │                │
│  └─────────────────┘                │
│                                     │
│                ┌─────────────────┐  │ ← Your message
│                │ I'm good! Thanks│  │
│                │ for asking      │  │
│                │ 12:31           │  │
│                └─────────────────┘  │
│                                     │
├─────────────────────────────────────┤
│  [Type a message...]          [📤] │
└─────────────────────────────────────┘
```

### Profile Screen:
```
┌─────────────────────────────────────┐
│  ← Profile                          │
├─────────────────────────────────────┤
│  ╔═══════════════════════════════╗  │
│  ║                               ║  │
│  ║         👤                    ║  │ ← Gradient header
│  ║    Test Consumer              ║  │
│  ║    [🛍️ Consumer]              ║  │
│  ║                               ║  │
│  ╚═══════════════════════════════╝  │
│                                     │
│  📞 Phone Number                    │
│     +91 1234567890                  │
│                                     │
│  🌐 Language                        │
│     English                         │
│                                     │
│  👤 Account Type                    │
│     Consumer                        │
│                                     │
│  [🚪 Logout]                        │
└─────────────────────────────────────┘
```

## 🔍 Console Logs to Watch

### When Opening Chat List:
```
🔵 Loading consumer chat list...
✅ Current user: Test Consumer (ID: 65abc123...)
💬 Fetching conversations...
📡 Response status: 200
✅ Loaded 3 conversations
```

### When Opening Chat Detail:
```
💬 Opening chat with: Test Farmer
🔵 Loading chat with Test Farmer...
✅ Current user ID: 65abc123...
✅ Other user ID: 65def456...
🔵 Fetching messages between 65abc123... and 65def456...
📡 Response status: 200
✅ Loaded 5 messages
```

### When Sending Message:
```
📤 Sending message: Hello!
🔵 Sending message from 65abc123... to 65def456...
📝 Content: Hello!
📡 Response status: 201
✅ Message sent successfully
🔵 Fetching messages between 65abc123... and 65def456...
✅ Loaded 6 messages
```

### Auto-Refresh (Every 3 seconds):
```
🔵 Fetching messages between 65abc123... and 65def456...
📡 Response status: 200
✅ Loaded 6 messages
```

## 🐛 Troubleshooting

### Issue 1: "No conversations yet" even after chatting
**Solution:**
- Check backend logs for errors
- Verify messages are being saved to MongoDB
- Check if user IDs are correct

### Issue 2: Messages not appearing
**Solution:**
- Check console logs for API errors
- Verify backend is running
- Check MongoDB connection
- Ensure user IDs match

### Issue 3: Chat list not updating
**Solution:**
- Pull down to refresh
- Check backend logs
- Verify conversation grouping logic

### Issue 4: Unread badges not showing
**Solution:**
- Check if messages are marked as read
- Verify unread count calculation
- Check backend logs

## 📊 Backend API Endpoints

### Chat Endpoints:
- `GET /api/chat/conversations/:userId` - Get all conversations
- `GET /api/chat/messages/:userId1/:userId2` - Get messages between users
- `POST /api/chat/messages` - Send a message
- `PUT /api/chat/messages/read` - Mark messages as read

### Request/Response Examples:

**Get Conversations:**
```
GET /api/chat/conversations/65abc123...

Response:
{
  "success": true,
  "conversations": [
    {
      "otherUser": {
        "_id": "65def456...",
        "name": "Test Farmer",
        "profileImage": {...},
        "userType": "farmer"
      },
      "lastMessage": {
        "content": "Hello!",
        "createdAt": "2026-02-05T...",
        "sender": "65def456..."
      },
      "unreadCount": 2
    }
  ]
}
```

**Send Message:**
```
POST /api/chat/messages
Body: {
  "sender": "65abc123...",
  "receiver": "65def456...",
  "content": "Hello!"
}

Response:
{
  "success": true,
  "message": {
    "_id": "65ghi789...",
    "sender": {...},
    "receiver": {...},
    "content": "Hello!",
    "read": false,
    "createdAt": "2026-02-05T..."
  }
}
```

## ✅ Success Criteria

- [ ] Consumer home shows community (no tabs)
- [ ] Chat icon opens chat list
- [ ] Profile icon opens profile page
- [ ] Floating chatbot works
- [ ] Can view all conversations
- [ ] Can send messages
- [ ] Messages appear in real-time (3s polling)
- [ ] Unread badges show correctly
- [ ] Message bubbles styled like WhatsApp
- [ ] Timestamps show correctly
- [ ] Can chat with farmers
- [ ] Farmers can chat with consumers
- [ ] Backend logs show all operations
- [ ] MongoDB stores messages correctly

## 🎉 Features Completed

✅ Redesigned consumer home (community only)
✅ Added profile page for consumers
✅ WhatsApp-style chat list
✅ Individual chat screens
✅ Real-time message polling
✅ Unread message tracking
✅ Message read receipts
✅ Backend chat system
✅ MongoDB message storage
✅ Comprehensive logging
✅ Error handling

---

**Backend Status:** ✅ Running (Port 5000)
**MongoDB Status:** ✅ Connected
**Ready to Test:** ✅ Yes

**Next Step:** Run `flutter run` and start testing!

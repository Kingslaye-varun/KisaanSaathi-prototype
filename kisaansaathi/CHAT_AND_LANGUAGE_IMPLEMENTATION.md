# Chat System & Language Switcher Implementation

## Overview
This document describes the implementation of two major features:
1. **Two-way Chat System** - Farmers and consumers can chat with each other from community posts
2. **Language Switcher** - Users can change the app language from the home screen

---

## 1. TWO-WAY CHAT SYSTEM

### Features Implemented

#### A. Farmer-to-Farmer & Farmer-to-Consumer Chat
- **Location**: Community screen post cards
- **Trigger**: Click the message icon on any post
- **Flow**:
  1. User clicks message icon on a post
  2. Opens chat detail screen with the post author
  3. Real-time messaging with 3-second polling
  4. Messages are stored in MongoDB via backend API

#### B. Chat Components

**Frontend Files Created/Modified:**
- `lib/screens/farmer_chat_detail_screen.dart` - NEW
  - Chat interface for farmers
  - Real-time message polling (every 3 seconds)
  - Send/receive messages
  - WhatsApp-style UI with message bubbles
  
- `lib/screens/consumer_chat_detail_screen.dart` - EXISTING
  - Chat interface for consumers
  - Same features as farmer chat
  
- `lib/screens/consumer_chat_list_screen.dart` - EXISTING
  - Lists all conversations for consumers
  - Shows unread message counts
  - Last message preview
  
- `lib/screens/community_screen.dart` - MODIFIED
  - Added navigation to chat from post cards
  - Message icon now opens chat with post author
  - Passes author details (ID, name, image) to chat screen

**Backend Files (Already Existing):**
- `backend/routes/chat.js`
  - GET `/api/chat/conversations/:userId` - Get all conversations
  - GET `/api/chat/messages/:userId1/:userId2` - Get messages between two users
  - POST `/api/chat/messages` - Send a message
  - PUT `/api/chat/messages/read` - Mark messages as read
  
- `backend/models/Message.js`
  - Schema: sender, receiver, content, createdAt, read status
  - Supports both Farmer and Consumer models

**Services:**
- `lib/services/chat_service.dart` - EXISTING
  - `getConversations(userId)` - Fetch all conversations
  - `getMessages(userId1, userId2)` - Fetch messages between two users
  - `sendMessage(senderId, receiverId, content)` - Send a message

### How It Works

1. **Starting a Chat from Community Post:**
   ```dart
   // User clicks message icon on post
   _navigateToChat(post.authorId)
   
   // Opens FarmerChatDetailScreen with:
   - otherUserId: post.authorId
   - otherUserName: post.authorName
   - otherUserImage: post.authorProfileImage
   - otherUserType: 'farmer'
   ```

2. **Message Flow:**
   ```
   User A (Farmer) → Clicks message icon on User B's post
   → Opens FarmerChatDetailScreen
   → Loads existing messages from backend
   → User A types and sends message
   → Message saved to MongoDB
   → User B sees message (via polling every 3 seconds)
   → User B replies
   → Both users see real-time conversation
   ```

3. **Database Structure:**
   ```javascript
   Message {
     sender: ObjectId (Farmer/Consumer),
     senderModel: 'Farmer' | 'Consumer',
     receiver: ObjectId (Farmer/Consumer),
     receiverModel: 'Farmer' | 'Consumer',
     content: String,
     read: Boolean,
     createdAt: Date
   }
   ```

### Testing the Chat System

1. **As Farmer:**
   - Go to Community screen
   - Find any post
   - Click the message icon (green chat bubble)
   - Chat screen opens with that farmer
   - Send a message
   - Wait 3 seconds to see if other user replies

2. **As Consumer:**
   - Go to Community screen (main screen)
   - Find any farmer's post
   - Click the message icon
   - Chat screen opens
   - Send a message to the farmer

3. **View All Chats:**
   - Consumers: Click chat icon in app bar
   - Shows list of all conversations
   - Click any conversation to open chat

---

## 2. LANGUAGE SWITCHER

### Features Implemented

#### A. Language Selection Widget
- **Location**: Top right of home screen (next to notifications)
- **Icon**: Globe icon (🌐)
- **Supported Languages**: 10 Indian languages + English

#### B. Supported Languages
1. English (en) 🇬🇧
2. Malayalam (ml) 🇮🇳
3. Hindi (hi) 🇮🇳
4. Punjabi (pa) 🇮🇳
5. Bengali (bn) 🇮🇳
6. Tamil (ta) 🇮🇳
7. Telugu (te) 🇮🇳
8. Marathi (mr) 🇮🇳
9. Gujarati (gu) 🇮🇳
10. Kannada (kn) 🇮🇳

#### C. Files Created/Modified

**New Files:**
- `lib/widgets/language_switcher.dart`
  - Reusable language switcher widget
  - Shows modal bottom sheet with language list
  - Saves preference to SharedPreferences
  - Updates app locale immediately

**Modified Files:**
- `lib/screens/farmer_home_screen_new.dart`
  - Added LanguageSwitcher widget to AppBar
  - Positioned before notifications icon
  
- `lib/screens/consumer_home_screen.dart`
  - Added LanguageSwitcher widget to AppBar
  - Positioned before chat icon

**Existing Files (Already Set Up):**
- `lib/l10n/app_localizations.dart`
  - Contains translations for all strings
  - Supports all 10 languages
  
- `lib/main.dart`
  - Localization delegates configured
  - Locale management via KisaanSaathiApp state
  - Saves/loads language preference

### How It Works

1. **User Clicks Language Icon:**
   ```dart
   // Opens bottom sheet with language list
   showModalBottomSheet(...)
   ```

2. **User Selects Language:**
   ```dart
   // Saves to SharedPreferences
   await prefs.setString('selectedLanguage', languageName);
   
   // Updates app locale
   KisaanSaathiApp.of(context).setLocale(Locale(languageCode));
   
   // Shows confirmation
   ScaffoldMessenger.of(context).showSnackBar(...)
   ```

3. **App Restarts with Saved Language:**
   ```dart
   // In main.dart
   final savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
   final locale = _getLocaleFromLanguage(savedLanguage);
   runApp(KisaanSaathiApp(initialLocale: locale));
   ```

### Using Localized Strings

```dart
// In any screen
import '../l10n/app_localizations.dart';

// Get localized string
final localizations = AppLocalizations.of(context);
Text(localizations.tellUsAboutYourFarm)
Text(localizations.getRecommendations)
Text(localizations.fertilizerGuide)
```

### Testing Language Switcher

1. **Change Language:**
   - Open app (Farmer or Consumer home)
   - Click globe icon (🌐) in top right
   - Select any language from the list
   - App immediately updates to selected language
   - Confirmation message appears

2. **Verify Persistence:**
   - Change language to Hindi
   - Close app completely
   - Reopen app
   - App should still be in Hindi

3. **Test Multiple Screens:**
   - Change to Malayalam
   - Navigate to different screens
   - All screens should show Malayalam text
   - (Note: Only screens using AppLocalizations will be translated)

---

## API Endpoints

### Chat Endpoints

```
Base URL: https://kisaansaathi-backend-sq7f.onrender.com/api/chat

GET /conversations/:userId
- Get all conversations for a user
- Returns: Array of conversations with last message and unread count

GET /messages/:userId1/:userId2
- Get all messages between two users
- Returns: Array of messages sorted by time

POST /messages
- Send a new message
- Body: { sender, receiver, content }
- Returns: Created message object

PUT /messages/read
- Mark messages as read
- Body: { sender, receiver }
- Returns: Success message
```

---

## Environment Variables

Ensure `.env` file contains:
```
NODE_API_URL=https://kisaansaathi-backend-sq7f.onrender.com
```

---

## Key Features

### Chat System
✅ Two-way communication between farmers and consumers
✅ Real-time message updates (3-second polling)
✅ WhatsApp-style UI with message bubbles
✅ Message history persistence
✅ Unread message indicators
✅ Conversation list view
✅ Direct chat from community posts
✅ Profile images in chat
✅ Timestamp display

### Language Switcher
✅ 10 Indian languages + English
✅ Instant language switching
✅ Persistent language preference
✅ Beautiful modal bottom sheet UI
✅ Flag emojis for each language
✅ Available on both farmer and consumer home screens
✅ Confirmation feedback

---

## Future Enhancements

### Chat System
- [ ] Push notifications for new messages
- [ ] WebSocket for real-time updates (replace polling)
- [ ] Image/file sharing in chat
- [ ] Voice messages
- [ ] Message search
- [ ] Block/report users
- [ ] Online/offline status indicators
- [ ] Typing indicators
- [ ] Message delivery/read receipts

### Language Switcher
- [ ] Add more regional languages
- [ ] Voice-based language selection
- [ ] Auto-detect language from device settings
- [ ] Language-specific fonts for better readability
- [ ] RTL support for languages like Urdu

---

## Troubleshooting

### Chat Not Working
1. Check backend is running: https://kisaansaathi-backend-sq7f.onrender.com
2. Verify `.env` file has correct NODE_API_URL
3. Check console logs for API errors
4. Ensure user is logged in (farmerId or consumerId exists)

### Language Not Changing
1. Check if screen uses AppLocalizations
2. Verify language code in app_localizations.dart
3. Check SharedPreferences for saved language
4. Restart app if language doesn't update

### Messages Not Appearing
1. Wait 3 seconds for polling to fetch new messages
2. Check network connection
3. Verify both users have valid IDs
4. Check backend logs for errors

---

## Summary

This implementation provides a complete two-way chat system allowing farmers and consumers to communicate directly from community posts, along with a comprehensive language switcher supporting 10 Indian languages. The chat system uses polling for real-time updates and stores all messages in MongoDB. The language switcher provides instant app-wide language changes with persistent preferences.

Both features are production-ready and fully integrated into the existing app architecture.

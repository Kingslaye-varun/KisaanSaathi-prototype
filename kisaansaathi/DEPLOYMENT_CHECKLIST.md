# Deployment Checklist - Consumer Feature to Render

## ✅ Pre-Deployment Checklist

### Backend Files to Push:
- [x] `backend/models/Consumer.js` - Consumer model
- [x] `backend/routes/consumers.js` - Consumer routes
- [x] `backend/server.js` - Updated with consumer routes

### Frontend Files (Already in repo):
- [x] `lib/services/consumer_service.dart`
- [x] `lib/models/consumer.dart`
- [x] `lib/screens/consumer_home_screen.dart`
- [x] `lib/screens/login_screen.dart`
- [x] `lib/screens/signup_screen.dart`
- [x] `lib/main.dart`

### Configuration:
- [x] `.env` - Updated to use Render URL

## 🚀 Deployment Steps

### Step 1: Commit Backend Changes
```bash
git add backend/models/Consumer.js
git add backend/routes/consumers.js
git add backend/server.js
git commit -m "Add consumer stakeholder feature with registration, login, and limited UI"
```

### Step 2: Commit Frontend Changes
```bash
git add lib/services/consumer_service.dart
git add lib/models/consumer.dart
git add lib/screens/consumer_home_screen.dart
git add lib/screens/login_screen.dart
git add lib/screens/signup_screen.dart
git add lib/main.dart
git commit -m "Add consumer UI with user type selection and limited features"
```

### Step 3: Push to GitHub
```bash
git push origin main
```

### Step 4: Render Auto-Deploy
Render will automatically detect the changes and deploy.

**Monitor deployment at:**
https://dashboard.render.com/

### Step 5: Wait for Deployment
- Render will rebuild the backend
- This takes about 2-5 minutes
- Watch the logs in Render dashboard

### Step 6: Verify Deployment
Once deployed, test the API:
```bash
curl https://kisaansaathi-backend-sq7f.onrender.com/api/consumers/test
```

Should return JSON (even if 404 error, that's fine - means it's responding)

## 🧪 Post-Deployment Testing

### Test 1: Consumer Registration
1. Open app
2. Click "Sign up"
3. Select "Consumer"
4. Fill details
5. Register

**Expected:** Success message and navigate to Consumer Home

### Test 2: Consumer Login
1. Logout
2. Click "Login"
3. Select "Consumer"
4. Enter registered phone
5. Login

**Expected:** Navigate to Consumer Home

### Test 3: Farmer Registration (Verify no breaking changes)
1. Register as Farmer
2. Should work as before

**Expected:** Navigate to Farmer Home with 4 tabs

## 📊 Render Environment Variables

Make sure these are set in Render dashboard:

```
MONGODB_URI=mongodb+srv://...
PORT=5000
CLOUDINARY_CLOUD_NAME=dawg7faz9
CLOUDINARY_API_KEY=741173291167753
CLOUDINARY_API_SECRET=Ujg2tvR-z6ttRwEoSJYEtT5qWvY
```

## 🔍 Monitoring

### Check Render Logs:
1. Go to Render dashboard
2. Click on your service
3. Go to "Logs" tab
4. Watch for:
   - "Server running on port 5000"
   - "MongoDB connected"
   - POST requests to /api/consumers/register

### Check MongoDB:
1. Go to MongoDB Atlas
2. Check "consumers" collection
3. Should see new consumer documents after registration

## ⚠️ Important Notes

### Database Collections:
After first consumer registration, MongoDB will automatically create:
- `consumers` collection (new)
- `farmers` collection (existing)
- `posts` collection (existing)

### API Endpoints Now Available:
- `POST /api/consumers/register` - Register consumer
- `GET /api/consumers/:phoneNumber` - Get consumer
- `PUT /api/consumers/:phoneNumber` - Update consumer
- All existing farmer endpoints still work

## 🐛 Troubleshooting

### Issue: Render build fails
**Check:**
- All files committed and pushed
- package.json has all dependencies
- No syntax errors in new files

### Issue: App still shows "HTML instead of JSON"
**Solution:**
1. Wait for Render deployment to complete
2. Restart Flutter app
3. Clear app data if needed

### Issue: Consumer registration fails on production
**Check:**
1. Render logs for errors
2. MongoDB connection
3. Cloudinary credentials

## 📱 Flutter App Update

After Render deployment is complete:

### Step 1: Restart Flutter App
```bash
# Stop current app (press 'q')
flutter run
```

### Step 2: Test on Production
- App will now use Render backend
- Test consumer registration
- Test consumer login
- Test all features

## ✅ Deployment Success Criteria

- [ ] Backend deployed to Render successfully
- [ ] Render logs show "Server running" and "MongoDB connected"
- [ ] Consumer registration works on production
- [ ] Consumer login works on production
- [ ] Consumer Home shows 2 tabs + chatbot
- [ ] Farmer features still work (no breaking changes)
- [ ] MongoDB shows consumers collection
- [ ] All API endpoints respond correctly

## 🎉 Post-Deployment

Once everything is working:

1. **Test thoroughly** with multiple users
2. **Monitor Render logs** for any errors
3. **Check MongoDB** for data integrity
4. **Gather user feedback**
5. **Document any issues**

## 📝 Git Commands Summary

```bash
# Add all changes
git add .

# Commit with message
git commit -m "Add consumer stakeholder feature - registration, login, and limited UI access"

# Push to GitHub (triggers Render deployment)
git push origin main

# Check status
git status
```

## 🔗 Important URLs

- **Render Dashboard:** https://dashboard.render.com/
- **Backend URL:** https://kisaansaathi-backend-sq7f.onrender.com
- **MongoDB Atlas:** https://cloud.mongodb.com/
- **GitHub Repo:** (your repo URL)

---

**Current Status:**
- ✅ .env updated to use Render URL
- ✅ All backend files ready
- ✅ All frontend files ready
- ⏳ Ready to push to GitHub

**Next Steps:**
1. Commit changes: `git add . && git commit -m "Add consumer feature"`
2. Push to GitHub: `git push origin main`
3. Wait for Render deployment (2-5 minutes)
4. Test on production

**Render URL:** https://kisaansaathi-backend-sq7f.onrender.com

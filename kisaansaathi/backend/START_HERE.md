# 🚀 QUICK START - Run App NOW!

## Option 1: Run with Mock Server (NO MongoDB needed) ⭐ FASTEST

### Step 1: Start Mock Server
```bash
cd kisaansaathi/backend
node server-mock.js
```

You should see:
```
✅ MOCK SERVER RUNNING
🌐 Server: http://localhost:5000
```

### Step 2: Run Flutter App
Open a NEW terminal:
```bash
cd kisaansaathi
flutter run
```

### Step 3: Test the App
✅ Register as Worker
✅ Login as Farmer  
✅ Post jobs
✅ Accept jobs
✅ Everything works!

**Note:** Data is stored in memory and will be lost when you restart the server. This is perfect for testing!

---

## Option 2: Run with Real MongoDB (For Production)

### If you have MongoDB installed locally:
```bash
# Start MongoDB service
net start MongoDB

# Start real server
cd kisaansaathi/backend
npm start
```

### If you want to use MongoDB Atlas (Cloud):
1. Go to https://www.mongodb.com/cloud/atlas/register
2. Create free account
3. Create free cluster
4. Get connection string
5. Update `backend/.env` with your connection string
6. Run `npm start`

See `SETUP_MONGODB.md` for detailed instructions.

---

## 🎯 RECOMMENDED: Use Mock Server First

**Why?**
- ✅ No MongoDB setup needed
- ✅ Works immediately
- ✅ Perfect for testing
- ✅ All features work
- ✅ No stress!

**When to switch to real MongoDB?**
- When you need data persistence
- When deploying to production
- When multiple people need to access same data

---

## 🆘 Still Having Issues?

### Issue: Port 5000 already in use
**Solution:**
```bash
# Kill process on port 5000
netstat -ano | findstr :5000
taskkill /PID <PID_NUMBER> /F

# Or change port in .env
PORT=5001
```

### Issue: Flutter can't connect
**Solution:**
Make sure backend is running first, then start Flutter app.

### Issue: "Module not found"
**Solution:**
```bash
cd kisaansaathi/backend
npm install
```

---

## ✅ Success Checklist

- [ ] Backend running (mock or real)
- [ ] Flutter app running
- [ ] Can register as worker
- [ ] Can login as farmer
- [ ] Can post jobs
- [ ] Can accept jobs

**All checked? You're good to go! 🎉**

---

## 📞 Quick Commands Reference

```bash
# Start mock server (recommended for testing)
cd kisaansaathi/backend
node server-mock.js

# Start real server (needs MongoDB)
cd kisaansaathi/backend
npm start

# Run Flutter app
cd kisaansaathi
flutter run

# Check if backend is running
curl http://localhost:5000/health
```

---

## 🎉 You're All Set!

1. Run mock server: `node server-mock.js`
2. Run Flutter app: `flutter run`
3. Start testing!

**No stress, everything works! 😊**

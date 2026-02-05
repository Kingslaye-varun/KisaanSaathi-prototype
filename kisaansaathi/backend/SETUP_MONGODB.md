# MongoDB Setup Guide - Quick Fix

## Option 1: Use MongoDB Atlas (Cloud - Easiest) ⭐ RECOMMENDED

### Step 1: Create Free MongoDB Atlas Account
1. Go to https://www.mongodb.com/cloud/atlas/register
2. Sign up for free (no credit card needed)
3. Create a free cluster (M0 Sandbox)

### Step 2: Get Connection String
1. Click "Connect" on your cluster
2. Choose "Connect your application"
3. Copy the connection string (looks like):
   ```
   mongodb+srv://username:<password>@cluster0.xxxxx.mongodb.net/kisaansaathi?retryWrites=true&w=majority
   ```

### Step 3: Update .env File
1. Open `backend/.env`
2. Replace `MONGODB_URI` with your connection string
3. Replace `<password>` with your actual password
4. Save the file

### Step 4: Whitelist Your IP
1. In Atlas, go to "Network Access"
2. Click "Add IP Address"
3. Click "Allow Access from Anywhere" (for development)
4. Confirm

### Step 5: Restart Backend
```bash
cd kisaansaathi/backend
npm start
```

✅ Should connect successfully!

---

## Option 2: Install MongoDB Locally (Windows)

### Step 1: Download MongoDB
1. Go to https://www.mongodb.com/try/download/community
2. Download MongoDB Community Server for Windows
3. Run the installer
4. Choose "Complete" installation
5. Install as a Windows Service (check the box)

### Step 2: Verify Installation
Open Command Prompt and run:
```bash
mongod --version
```

### Step 3: Start MongoDB Service
```bash
net start MongoDB
```

### Step 4: Update .env
The `.env` file is already configured for local MongoDB:
```
MONGODB_URI=mongodb://localhost:27017/kisaansaathi
```

### Step 5: Restart Backend
```bash
cd kisaansaathi/backend
npm start
```

✅ Should connect successfully!

---

## Option 3: Quick Test Without MongoDB (Temporary)

If you just want to test the frontend without database:

### Create Mock Server
Create `backend/server-mock.js`:

```javascript
require('dotenv').config();
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Mock data
let workers = [];
let workRequests = [];

// Worker routes
app.post('/api/workers/register', (req, res) => {
  const worker = {
    _id: Date.now().toString(),
    ...req.body,
    createdAt: new Date()
  };
  workers.push(worker);
  res.status(201).json({ success: true, worker });
});

app.get('/api/workers/phone/:phoneNumber', (req, res) => {
  const worker = workers.find(w => w.phoneNumber === req.params.phoneNumber);
  if (worker) {
    res.json({ success: true, worker });
  } else {
    res.status(404).json({ success: false, message: 'Worker not found' });
  }
});

// Work request routes
app.post('/api/work-requests/create', (req, res) => {
  const request = {
    _id: Date.now().toString(),
    ...req.body,
    status: 'Pending',
    createdAt: new Date()
  };
  workRequests.push(request);
  res.status(201).json({ success: true, workRequest: request });
});

app.get('/api/work-requests/open', (req, res) => {
  const open = workRequests.filter(r => r.status === 'Pending');
  res.json({ success: true, workRequests: open });
});

app.put('/api/work-requests/accept/:requestId', (req, res) => {
  const request = workRequests.find(r => r._id === req.params.requestId);
  if (request) {
    request.status = 'Accepted';
    request.workerId = req.body.workerId;
    request.workerName = req.body.workerName;
    request.acceptedAt = new Date();
    res.json({ success: true, workRequest: request });
  } else {
    res.status(404).json({ success: false, message: 'Request not found' });
  }
});

app.listen(PORT, () => {
  console.log(`✅ Mock server running on port ${PORT}`);
  console.log('⚠️  Using in-memory storage (data will be lost on restart)');
});
```

### Run Mock Server
```bash
node server-mock.js
```

---

## Troubleshooting

### Error: "MONGODB_URI is undefined"
✅ **Fixed!** The `.env` file has been created with the correct configuration.

### Error: "Connection timed out"
- Check if MongoDB is running: `net start MongoDB`
- Or use MongoDB Atlas (cloud option)

### Error: "Authentication failed"
- Check your MongoDB Atlas password
- Make sure you replaced `<password>` in the connection string

---

## Quick Start (Recommended)

**For fastest setup, use MongoDB Atlas:**

1. Create account at https://www.mongodb.com/cloud/atlas/register
2. Create free cluster
3. Get connection string
4. Update `backend/.env` with your connection string
5. Whitelist your IP
6. Run `npm start`

**Done! 🎉**

---

## Current Status

✅ `.env` file created
✅ Default MongoDB URI configured (localhost)
⏳ Need to either:
   - Install MongoDB locally, OR
   - Use MongoDB Atlas (recommended)

Choose one option above and follow the steps!

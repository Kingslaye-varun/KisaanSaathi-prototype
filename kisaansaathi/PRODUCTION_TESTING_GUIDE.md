# 🚀 Production Testing Guide - Real MongoDB

## ✅ Your Setup is Ready!

Your MongoDB Atlas and Cloudinary are configured:
- ✅ MongoDB URI: Connected to Cluster0
- ✅ Cloudinary: Configured for image uploads
- ✅ All routes: Properly registered
- ✅ All models: Created and ready

---

## 🎯 Step-by-Step Testing

### Step 1: Start Backend Server

```bash
cd kisaansaathi/backend
npm start
```

**Expected Output:**
```
Server running on port 5000
MongoDB connected
```

**If you see "MongoDB connected" ✅ - You're good to go!**

---

### Step 2: Start Flutter App

Open a NEW terminal:
```bash
cd kisaansaathi
flutter run
```

---

### Step 3: Test Worker Registration

1. **Open App** → Select "Worker" card
2. **Click "Sign up"**
3. **Fill in details:**
   - Name: "John Worker"
   - Phone: "9876543210"
   - Upload a profile photo
   - Select language: "English"
4. **Click "Continue"**

**Expected Result:**
- ✅ Registration succeeds
- ✅ Profile image uploads to Cloudinary
- ✅ Redirected to Worker Home Screen
- ✅ Data saved to MongoDB

**Check MongoDB:**
- Collection: `workers`
- Should have 1 document with your worker data

---

### Step 4: Test Farmer Job Posting

1. **Login as Farmer**
   - Phone: Use existing farmer phone or create new farmer
   
2. **Navigate to Hire Worker**
   - From Farmer Home Screen
   - Click "Hire Worker" card (indigo color, bottom right)

3. **Post a Job:**
   - Work Type: Select "Harvesting"
   - Payment Amount: 500
   - Description: "Need help harvesting rice crop. 2 acres of land."
   - Click "Post Job"

**Expected Result:**
- ✅ Success message appears
- ✅ Form clears
- ✅ Job appears in "My Posted Jobs" section
- ✅ Status shows "Pending" (orange badge)

**Check MongoDB:**
- Collection: `workrequests`
- Should have 1 document with status: "Pending"

---

### Step 5: Test Worker Job Browsing

1. **Login as Worker** (phone: 9876543210)
2. **View "Available Jobs" tab**
3. **See the job you posted**

**Expected Result:**
- ✅ Job card displays:
  - Work Type: "Harvesting"
  - Payment: "₹500"
  - Description: Full job description
  - Farmer Name: Name of farmer who posted
- ✅ "Call Farmer" button visible
- ✅ "Accept Job" button visible

---

### Step 6: Test Job Acceptance

1. **As Worker, click "Accept Job"**
2. **Confirm in dialog**

**Expected Result:**
- ✅ Success message: "Job accepted successfully!"
- ✅ Job disappears from "Available Jobs"
- ✅ Job appears in "My Jobs" tab
- ✅ Status changed to "Accepted"

**Check MongoDB:**
- Collection: `workrequests`
- Document should now have:
  - status: "Accepted"
  - workerId: Worker's ID
  - workerName: "John Worker"
  - acceptedAt: Timestamp

---

### Step 7: Verify Farmer Side

1. **Login as Farmer**
2. **Go to "Hire Worker"**
3. **Check "My Posted Jobs"**

**Expected Result:**
- ✅ Job status changed to "Accepted" (green badge)
- ✅ Worker name displayed: "Accepted by: John Worker"
- ✅ Delete button removed (can't delete accepted jobs)

---

### Step 8: Test Phone Dialer

1. **As Worker, in job card**
2. **Click "Call Farmer" button**

**Expected Result:**
- ✅ Phone dialer opens
- ✅ Farmer's phone number pre-filled
- ✅ Ready to make call

**Note:** This only works on physical devices, not emulators.

---

### Step 9: Test Job Deletion

1. **As Farmer, post another job**
2. **Before anyone accepts, click "Delete"**
3. **Confirm deletion**

**Expected Result:**
- ✅ Job deleted from list
- ✅ Job removed from MongoDB
- ✅ Workers can't see it anymore

---

## 🔍 Verification Checklist

### Backend Verification
- [ ] Server starts without errors
- [ ] "MongoDB connected" message appears
- [ ] No connection timeout errors
- [ ] All routes registered

### Worker Flow
- [ ] Can register with profile image
- [ ] Image uploads to Cloudinary
- [ ] Can login with phone number
- [ ] Sees all available jobs
- [ ] Can accept jobs
- [ ] Accepted jobs appear in "My Jobs"
- [ ] Can call farmer (on device)

### Farmer Flow
- [ ] Can access "Hire Worker" screen
- [ ] Can post jobs with all details
- [ ] Jobs appear in "My Posted Jobs"
- [ ] Can see job status updates
- [ ] Can see worker name when accepted
- [ ] Can delete pending jobs
- [ ] Cannot delete accepted jobs

### Database Verification
- [ ] Workers collection has documents
- [ ] WorkRequests collection has documents
- [ ] Status updates correctly
- [ ] Worker info recorded on acceptance
- [ ] Timestamps recorded correctly

---

## 📊 MongoDB Collections Structure

### Workers Collection
```javascript
{
  _id: ObjectId("..."),
  name: "John Worker",
  phoneNumber: "9876543210",
  language: "English",
  profileImage: {
    url: "https://res.cloudinary.com/...",
    publicId: "kisaansaathi/workers/..."
  },
  createdAt: ISODate("2026-02-05T..."),
  updatedAt: ISODate("2026-02-05T...")
}
```

### WorkRequests Collection
```javascript
{
  _id: ObjectId("..."),
  farmerId: ObjectId("..."),
  farmerName: "Test Farmer",
  farmerPhone: "1234567890",
  workType: "Harvesting",
  paymentAmount: 500,
  description: "Need help harvesting rice crop...",
  status: "Accepted",
  workerId: ObjectId("..."),
  workerName: "John Worker",
  acceptedAt: ISODate("2026-02-05T..."),
  createdAt: ISODate("2026-02-05T..."),
  updatedAt: ISODate("2026-02-05T...")
}
```

---

## 🐛 Troubleshooting

### Issue: "MongoDB connection error"
**Check:**
1. MongoDB URI is correct in `.env`
2. Your IP is whitelisted in MongoDB Atlas
3. Password in URI is correct (no special characters issues)

**Solution:**
```bash
# In MongoDB Atlas:
1. Go to Network Access
2. Add IP Address
3. Allow Access from Anywhere (0.0.0.0/0)
4. Save
```

### Issue: "Worker registration fails"
**Check:**
1. Backend server is running
2. MongoDB is connected
3. Cloudinary credentials are correct

**Solution:**
- Check backend console for error messages
- Verify `.env` file has all credentials
- Test with smaller image (<2MB)

### Issue: "Jobs not appearing"
**Check:**
1. Backend server is running
2. MongoDB connection is active
3. Pull-to-refresh on Worker Home

**Solution:**
- Restart backend server
- Check MongoDB Atlas for documents
- Verify farmerId is correct

### Issue: "Image upload fails"
**Check:**
1. Cloudinary credentials in `.env`
2. Image size (<5MB recommended)
3. Internet connection

**Solution:**
- Registration still succeeds without image
- Check Cloudinary dashboard for upload errors
- Try with smaller image

---

## 🎯 Performance Testing

### Test Multiple Jobs
1. Post 5-10 jobs as farmer
2. Check they all appear for workers
3. Accept multiple jobs as worker
4. Verify all status updates correctly

### Test Multiple Workers
1. Register 2-3 workers
2. Post jobs as farmer
3. Have different workers accept different jobs
4. Verify each worker sees only their accepted jobs

### Test Concurrent Access
1. Have farmer and worker logged in simultaneously
2. Farmer posts job
3. Worker refreshes and sees job immediately
4. Worker accepts job
5. Farmer refreshes and sees status update

---

## ✅ Success Criteria

**System is working correctly if:**
- ✅ Workers can register and login
- ✅ Images upload to Cloudinary
- ✅ Farmers can post jobs
- ✅ Workers can see all available jobs
- ✅ Workers can accept jobs
- ✅ Status updates in real-time
- ✅ Farmer sees which worker accepted
- ✅ Data persists in MongoDB
- ✅ No crashes or errors
- ✅ Phone dialer works (on device)

---

## 📞 API Endpoints Reference

### Worker Endpoints
```
POST   /api/workers/register          - Register new worker
GET    /api/workers/phone/:phone      - Get worker by phone
GET    /api/workers/:id               - Get worker by ID
```

### Work Request Endpoints
```
POST   /api/work-requests/create      - Create job posting
GET    /api/work-requests/open        - Get all pending jobs
GET    /api/work-requests/farmer/:id  - Get farmer's jobs
GET    /api/work-requests/worker/:id  - Get worker's jobs
PUT    /api/work-requests/accept/:id  - Accept a job
DELETE /api/work-requests/:id         - Delete a job
```

---

## 🎉 Production Ready!

Once all tests pass:
- ✅ System is production ready
- ✅ All features functional
- ✅ Data persists correctly
- ✅ Images upload successfully
- ✅ Real-time updates work
- ✅ Ready for deployment!

---

## 📝 Next Steps

After successful testing:
1. ✅ Test on physical device
2. ✅ Test with real users
3. ✅ Monitor MongoDB Atlas metrics
4. ✅ Check Cloudinary usage
5. ✅ Optimize if needed
6. ✅ Deploy to production

---

**Everything is configured and ready! Just start the server and test! 🚀**

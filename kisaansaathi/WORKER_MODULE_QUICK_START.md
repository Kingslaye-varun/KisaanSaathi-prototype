# Worker Hiring Module - Quick Start Guide

## 🚀 Getting Started

### Prerequisites
- MongoDB running locally or remotely
- Node.js backend server running
- Flutter development environment set up
- Android/iOS emulator or physical device

### Backend Setup

1. **Install Dependencies** (if not already done)
```bash
cd kisaansaathi/backend
npm install
```

2. **Start the Server**
```bash
npm start
```

The server should start on `http://localhost:5000`

### Flutter Setup

1. **Get Dependencies**
```bash
cd kisaansaathi
flutter pub get
```

2. **Run the App**
```bash
flutter run
```

## 📱 Testing the Worker Hiring Module

### Test as a Worker

1. **Register as Worker**
   - Open the app
   - Select "Worker" card on login screen
   - Click "Sign up"
   - Fill in:
     - Name: "John Worker"
     - Phone: "9876543210"
     - Upload profile photo
     - Select language
   - Click "Continue"

2. **Browse Jobs**
   - You'll be redirected to Worker Home Screen
   - See "Available Jobs" tab with all open jobs
   - Each job card shows:
     - Work type (e.g., "Harvesting")
     - Payment amount (e.g., "₹500")
     - Description
     - Farmer name

3. **Accept a Job**
   - Click "Accept Job" button
   - Confirm in the dialog
   - Job moves to "My Jobs" tab
   - Status changes to "Accepted"

4. **Call Farmer**
   - Click "Call Farmer" button
   - Phone dialer opens with farmer's number
   - Make the call

### Test as a Farmer

1. **Login as Farmer**
   - Use existing farmer credentials
   - Or register as new farmer

2. **Post a Job**
   - From Farmer Home Screen
   - Click "Hire Worker" card
   - Fill in the form:
     - Work Type: Select from dropdown or choose "Other"
     - Payment Amount: Enter wage (e.g., 500)
     - Description: Describe the work
   - Click "Post Job"

3. **View Posted Jobs**
   - Scroll down to see "My Posted Jobs"
   - See job status (Pending/Accepted)
   - If accepted, see worker's name
   - Delete pending jobs if needed

## 🧪 Test Scenarios

### Scenario 1: Complete Job Flow
1. Farmer posts a harvesting job for ₹500
2. Worker logs in and sees the job
3. Worker calls farmer to discuss
4. Worker accepts the job
5. Farmer sees job status changed to "Accepted"
6. Farmer sees worker's name on the job card

### Scenario 2: Multiple Jobs
1. Farmer posts 3 different jobs
2. Worker browses all 3 jobs
3. Worker accepts 2 jobs
4. Worker sees 2 jobs in "My Jobs" tab
5. Farmer sees 2 accepted, 1 pending

### Scenario 3: Job Deletion
1. Farmer posts a job
2. Before anyone accepts, farmer deletes it
3. Job disappears from worker's available jobs
4. Job removed from farmer's list

## 🔍 Verification Points

### Worker Side
- ✅ Can register with profile image
- ✅ Can login with phone number
- ✅ Sees all available jobs
- ✅ Can call farmer (phone dialer opens)
- ✅ Can accept jobs
- ✅ Accepted jobs appear in "My Jobs"
- ✅ Pull-to-refresh updates job list

### Farmer Side
- ✅ Can access "Hire Worker" from home
- ✅ Can post jobs with all details
- ✅ Can select predefined work types
- ✅ Can enter custom work type
- ✅ Sees all posted jobs
- ✅ Sees job status updates
- ✅ Sees worker name when accepted
- ✅ Can delete pending jobs
- ✅ Cannot delete accepted jobs

## 🐛 Troubleshooting

### Issue: "Failed to fetch work requests"
**Solution:** 
- Check if backend server is running
- Verify MongoDB connection
- Check API URL in service files (should be `http://10.0.2.2:5000` for Android emulator)

### Issue: "Worker not found"
**Solution:**
- Register as worker first
- Check phone number format (10 digits)
- Verify backend worker routes are working

### Issue: "Call Farmer" button doesn't work
**Solution:**
- Ensure `url_launcher` package is installed
- Check phone permissions on device
- Verify farmer phone number is saved correctly

### Issue: Profile image not uploading
**Solution:**
- Check Cloudinary configuration in backend
- Verify image picker permissions
- Check image size (should be reasonable)

## 📊 Database Collections

After testing, verify these collections in MongoDB:

1. **workers**
   - Contains worker profiles
   - Fields: name, phoneNumber, language, profileImage

2. **workrequests**
   - Contains all job postings
   - Fields: farmerId, farmerName, workType, paymentAmount, status, etc.

## 🎨 UI Components

### Worker Home Screen
- **AppBar**: Title, refresh button, logout button
- **Bottom Navigation**: "Available Jobs" and "My Jobs" tabs
- **Job Cards**: Work type, payment, description, farmer info, action buttons

### Hire Worker Screen
- **Job Form**: Work type dropdown, payment input, description textarea
- **Posted Jobs List**: Cards showing status, worker info, delete option

## 📝 Sample Data

### Sample Work Types
- Harvesting
- Sowing
- Plowing
- Weeding
- Irrigation
- Fertilizer Application
- Pest Control
- General Farm Work

### Sample Job Posting
```
Work Type: Harvesting
Payment: ₹500
Description: Need help harvesting rice crop. 2 acres of land. Work duration: 2 days. Meals provided.
```

## 🔐 Test Credentials

### Test Farmer
- Phone: 1234567890
- Name: Test Farmer

### Test Worker
- Phone: 9876543210
- Name: Test Worker

## 📞 Support

If you encounter any issues:
1. Check the console logs for error messages
2. Verify all backend routes are registered in server.js
3. Ensure MongoDB is running and connected
4. Check network connectivity
5. Review the implementation documentation

## ✅ Success Criteria

The module is working correctly if:
1. ✅ Workers can register and login
2. ✅ Workers can see all available jobs
3. ✅ Workers can call farmers
4. ✅ Workers can accept jobs
5. ✅ Farmers can post jobs
6. ✅ Farmers can see job status
7. ✅ Farmers can see which worker accepted
8. ✅ Farmers can delete pending jobs
9. ✅ UI is responsive and user-friendly
10. ✅ No crashes or errors during normal use

## 🎉 Next Steps

After successful testing:
1. Add more work types based on regional needs
2. Implement push notifications
3. Add worker ratings system
4. Create job completion workflow
5. Add location-based job filtering
6. Implement in-app messaging

---

**Happy Testing! 🌾👨‍🌾**

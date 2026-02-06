# Worker Hiring Module Implementation Guide

## Overview
This document outlines the complete implementation of the Worker Hiring module for KisaanSaathi, a Request-Accept model connecting Farmers with Workers.

## Architecture

### User Roles
The app now supports three user roles:
1. **Farmer** - Can post jobs and hire workers
2. **Consumer** - Can buy products from farmers
3. **Worker** - Can browse and accept farm jobs

## Implementation Details

### 1. Data Models

#### Worker Model (`lib/models/worker.dart`)
- `id`: Unique identifier
- `name`: Worker's name
- `phoneNumber`: Contact number
- `language`: Preferred language
- `profileImageUrl`: Profile picture URL
- `createdAt`: Registration timestamp

#### WorkRequest Model (`lib/models/work_request.dart`)
- `id`: Unique identifier
- `farmerId`: ID of farmer posting the job
- `farmerName`: Name of farmer
- `farmerPhone`: Farmer's contact number
- `workType`: Type of work (Harvesting, Sowing, etc.)
- `paymentAmount`: Wage offered
- `description`: Job details
- `status`: 'Pending' or 'Accepted'
- `workerId`: ID of worker who accepted (optional)
- `workerName`: Name of worker who accepted (optional)
- `createdAt`: Job posting timestamp
- `acceptedAt`: Job acceptance timestamp (optional)

### 2. Backend Implementation

#### Database Models
- **Worker.js** (`backend/models/Worker.js`)
  - MongoDB schema for worker data
  - Phone number validation
  - Profile image storage via Cloudinary

- **WorkRequest.js** (`backend/models/WorkRequest.js`)
  - MongoDB schema for work requests
  - Status enum: ['Pending', 'Accepted']
  - References to Farmer and Worker collections

#### API Routes

**Worker Routes** (`backend/routes/workers.js`)
- `POST /api/workers/register` - Register new worker
- `GET /api/workers/phone/:phoneNumber` - Get worker by phone
- `GET /api/workers/:id` - Get worker by ID

**Work Request Routes** (`backend/routes/workRequests.js`)
- `POST /api/work-requests/create` - Create new job posting
- `GET /api/work-requests/open` - Get all pending jobs
- `GET /api/work-requests/farmer/:farmerId` - Get farmer's posted jobs
- `GET /api/work-requests/worker/:workerId` - Get worker's accepted jobs
- `PUT /api/work-requests/accept/:requestId` - Accept a job
- `DELETE /api/work-requests/:requestId` - Delete a job posting

### 3. Flutter Services

#### WorkerService (`lib/services/worker_service.dart`)
- `registerWorker()` - Register new worker with profile image
- `getWorkerByPhone()` - Login worker by phone number
- `getWorkerById()` - Fetch worker details

#### WorkRequestService (`lib/services/work_request_service.dart`)
- `createWorkRequest()` - Farmer posts a new job
- `getOpenWorkRequests()` - Fetch all available jobs
- `getFarmerWorkRequests()` - Fetch farmer's posted jobs
- `getWorkerJobs()` - Fetch worker's accepted jobs
- `acceptWorkRequest()` - Worker accepts a job
- `deleteWorkRequest()` - Farmer deletes a job posting

### 4. UI Screens

#### Worker Home Screen (`lib/screens/worker_home_screen.dart`)
**Features:**
- Two tabs: "Available Jobs" and "My Jobs"
- Job cards displaying:
  - Work type and payment amount
  - Job description
  - Farmer name
  - "Call Farmer" button (uses url_launcher)
  - "Accept Job" button
- Pull-to-refresh functionality
- Empty state handling

#### Hire Worker Screen (`lib/screens/hire_worker_screen.dart`)
**Features:**
- Job posting form with:
  - Work type dropdown (Harvesting, Sowing, Plowing, etc.)
  - Custom work type input for "Other"
  - Payment amount input
  - Job description text area
- List of farmer's posted jobs showing:
  - Job status (Pending/Accepted)
  - Worker name if accepted
  - Delete option for pending jobs
- Form validation
- Real-time updates after posting

#### Updated Authentication Screens
- **Login Screen** - Added Worker option with 3-card selection
- **Signup Screen** - Worker registration flow
- **Main.dart** - Added worker routes and navigation logic

### 5. Navigation Flow

#### Worker Flow
1. Login/Signup as Worker
2. Redirected to Worker Home Screen
3. Browse available jobs in "Available Jobs" tab
4. Call farmer or accept job
5. View accepted jobs in "My Jobs" tab

#### Farmer Flow
1. Login as Farmer
2. Access "Hire Worker" from home screen
3. Post new job with details
4. View posted jobs and their status
5. See which worker accepted the job
6. Delete pending jobs if needed

### 6. Key Features

#### For Workers
- ✅ Browse all available farm jobs
- ✅ View job details (type, payment, description)
- ✅ Call farmer directly from app
- ✅ Accept jobs with one tap
- ✅ Track accepted jobs
- ✅ Pull-to-refresh for latest jobs

#### For Farmers
- ✅ Post job with work type and payment
- ✅ Predefined work types + custom option
- ✅ View all posted jobs
- ✅ See job status (Pending/Accepted)
- ✅ Know which worker accepted
- ✅ Delete pending jobs
- ✅ Easy access from home screen

### 7. Design Consistency

The module follows KisaanSaathi's design system:
- **Color Palette**: Green shades (primary), earth tones
- **Typography**: Consistent font sizes and weights
- **Card Design**: Rounded corners (12px), subtle shadows
- **Buttons**: Green primary, outlined secondary
- **Icons**: Material Design icons
- **Spacing**: 8px, 12px, 16px, 24px increments

### 8. Error Handling

- Network error handling with user-friendly messages
- Form validation for all inputs
- Empty state handling for no jobs
- Confirmation dialogs for critical actions
- Loading states during API calls
- Phone number validation

### 9. Security Considerations

- Phone number validation (10 digits)
- User authentication via SharedPreferences
- API endpoint protection
- Input sanitization
- Secure image upload via Cloudinary

## Testing Checklist

### Worker Registration & Login
- [ ] Register new worker with profile image
- [ ] Login existing worker
- [ ] Handle invalid phone numbers
- [ ] Handle network errors

### Job Browsing (Worker)
- [ ] View all available jobs
- [ ] See job details correctly
- [ ] Call farmer functionality works
- [ ] Accept job successfully
- [ ] View accepted jobs in "My Jobs"
- [ ] Pull-to-refresh updates list

### Job Posting (Farmer)
- [ ] Post job with all details
- [ ] Select predefined work types
- [ ] Enter custom work type
- [ ] Form validation works
- [ ] View posted jobs
- [ ] See job status updates
- [ ] Delete pending jobs
- [ ] Cannot delete accepted jobs

### Navigation
- [ ] Worker redirected to worker home after login
- [ ] Farmer can access hire worker screen
- [ ] Back navigation works correctly
- [ ] Logout clears session

## Future Enhancements

1. **Job Filtering** - Filter by work type, payment range, location
2. **Worker Ratings** - Farmers can rate workers after job completion
3. **Job History** - Complete job history for both parties
4. **Push Notifications** - Notify workers of new jobs, farmers of acceptances
5. **In-App Messaging** - Direct chat between farmer and worker
6. **Location-Based Jobs** - Show nearby jobs to workers
7. **Multiple Workers** - Allow multiple workers to accept same job
8. **Job Completion** - Mark jobs as completed with payment confirmation
9. **Worker Profiles** - Detailed profiles with skills and experience
10. **Job Templates** - Save frequently posted job types

## API Endpoints Summary

```
Workers:
POST   /api/workers/register
GET    /api/workers/phone/:phoneNumber
GET    /api/workers/:id

Work Requests:
POST   /api/work-requests/create
GET    /api/work-requests/open
GET    /api/work-requests/farmer/:farmerId
GET    /api/work-requests/worker/:workerId
PUT    /api/work-requests/accept/:requestId
DELETE /api/work-requests/:requestId
```

## Dependencies

All required dependencies are already in `pubspec.yaml`:
- `http` - API calls
- `url_launcher` - Phone dialer integration
- `shared_preferences` - Local storage
- `image_picker` - Profile image selection

## Deployment Notes

1. Update backend server.js with new routes
2. Ensure MongoDB connection is configured
3. Set up Cloudinary for image uploads
4. Test all API endpoints
5. Update .env files with correct API URLs
6. Run `flutter pub get` to ensure dependencies
7. Test on both Android and iOS devices

## Conclusion

The Worker Hiring module is now fully integrated into KisaanSaathi, providing a seamless way for farmers to hire workers and for workers to find farm jobs. The implementation follows best practices, maintains design consistency, and provides a great user experience for both user types.

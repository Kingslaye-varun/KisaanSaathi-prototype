# Worker Hiring Module - Flow Diagrams

## 🔄 User Flow Diagrams

### Worker Registration & Job Acceptance Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        WORKER FLOW                               │
└─────────────────────────────────────────────────────────────────┘

1. REGISTRATION
   ┌──────────┐
   │  Login   │
   │  Screen  │
   └────┬─────┘
        │ Select "Worker"
        ▼
   ┌──────────┐
   │  Signup  │
   │  Screen  │
   └────┬─────┘
        │ Enter: Name, Phone, Photo
        ▼
   ┌──────────────┐
   │ Worker Home  │
   │   Screen     │
   └──────────────┘

2. BROWSING JOBS
   ┌──────────────────┐
   │  Available Jobs  │◄─── Pull to Refresh
   │      Tab         │
   └────────┬─────────┘
            │
            ├─► View Job Details
            │   • Work Type
            │   • Payment
            │   • Description
            │   • Farmer Name
            │
            ├─► Call Farmer
            │   └─► Phone Dialer Opens
            │
            └─► Accept Job
                └─► Confirmation Dialog
                    └─► Job Accepted
                        └─► Moves to "My Jobs"

3. MANAGING ACCEPTED JOBS
   ┌──────────────┐
   │  My Jobs Tab │
   └──────┬───────┘
          │
          ├─► View Accepted Jobs
          │   • Job Details
          │   • Farmer Contact
          │
          └─► Call Farmer
              └─► Coordinate Work
```

### Farmer Job Posting Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        FARMER FLOW                               │
└─────────────────────────────────────────────────────────────────┘

1. ACCESSING HIRE WORKER
   ┌──────────────┐
   │ Farmer Home  │
   │   Screen     │
   └──────┬───────┘
          │ Click "Hire Worker"
          ▼
   ┌──────────────────┐
   │ Hire Worker      │
   │    Screen        │
   └──────────────────┘

2. POSTING A JOB
   ┌─────────────────────┐
   │   Job Post Form     │
   └──────┬──────────────┘
          │
          ├─► Select Work Type
          │   • Harvesting
          │   • Sowing
          │   • Plowing
          │   • Other (Custom)
          │
          ├─► Enter Payment Amount
          │   └─► ₹ Amount
          │
          ├─► Write Description
          │   └─► Job Details
          │
          └─► Click "Post Job"
              └─► Job Created
                  └─► Appears in "My Posted Jobs"

3. MANAGING POSTED JOBS
   ┌──────────────────┐
   │ My Posted Jobs   │
   └────────┬─────────┘
            │
            ├─► View Job Status
            │   • Pending (Orange)
            │   • Accepted (Green)
            │
            ├─► See Worker Info
            │   └─► (If Accepted)
            │       • Worker Name
            │
            └─► Delete Job
                └─► (Only if Pending)
                    └─► Confirmation Dialog
                        └─► Job Deleted
```

## 🔀 System Architecture Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    SYSTEM ARCHITECTURE                           │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Flutter    │         │   Node.js    │         │   MongoDB    │
│     App      │◄───────►│   Backend    │◄───────►│   Database   │
└──────────────┘         └──────────────┘         └──────────────┘
      │                         │                         │
      │                         │                         │
      ├─ Worker Service         ├─ Worker Routes         ├─ workers
      │  • Register             │  • POST /register       │   collection
      │  • Login                │  • GET /phone/:phone    │
      │  • Get Profile          │  • GET /:id             │
      │                         │                         │
      ├─ WorkRequest Service    ├─ WorkRequest Routes    ├─ workrequests
      │  • Create               │  • POST /create         │   collection
      │  • Get Open             │  • GET /open            │
      │  • Accept               │  • PUT /accept/:id      │
      │  • Delete               │  • DELETE /:id          │
      │                         │                         │
      └─ UI Screens             └─ Cloudinary            └─ farmers
         • Worker Home             • Image Upload           collection
         • Hire Worker
```

## 📊 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      DATA FLOW                                   │
└─────────────────────────────────────────────────────────────────┘

WORKER REGISTRATION
┌────────┐    1. Submit Form    ┌─────────┐    2. Save Data    ┌──────────┐
│ Worker │─────────────────────►│ Backend │───────────────────►│ MongoDB  │
│   UI   │                      │  API    │                    │          │
└────────┘◄─────────────────────└─────────┘◄───────────────────└──────────┘
           3. Return Worker ID              4. Worker Document

JOB POSTING (FARMER)
┌────────┐    1. Post Job       ┌─────────┐    2. Create Doc   ┌──────────┐
│ Farmer │─────────────────────►│ Backend │───────────────────►│ MongoDB  │
│   UI   │                      │  API    │                    │          │
└────────┘◄─────────────────────└─────────┘◄───────────────────└──────────┘
           3. Return Job ID                 4. WorkRequest Doc

JOB BROWSING (WORKER)
┌────────┐    1. Request Jobs   ┌─────────┐    2. Query DB     ┌──────────┐
│ Worker │─────────────────────►│ Backend │───────────────────►│ MongoDB  │
│   UI   │                      │  API    │                    │          │
└────────┘◄─────────────────────└─────────┘◄───────────────────└──────────┘
           4. Display Jobs       3. Return Pending Jobs

JOB ACCEPTANCE
┌────────┐    1. Accept Job     ┌─────────┐    2. Update Doc   ┌──────────┐
│ Worker │─────────────────────►│ Backend │───────────────────►│ MongoDB  │
│   UI   │                      │  API    │                    │          │
└────────┘◄─────────────────────└─────────┘◄───────────────────└──────────┘
           4. Show Success       3. Status = Accepted
                                    + Worker Info
```

## 🎯 State Transitions

```
┌─────────────────────────────────────────────────────────────────┐
│                   WORK REQUEST STATES                            │
└─────────────────────────────────────────────────────────────────┘

                    ┌──────────────┐
                    │   CREATED    │
                    │  (by Farmer) │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │   PENDING    │◄──────┐
                    │  (Visible to │       │
                    │   Workers)   │       │
                    └──────┬───────┘       │
                           │               │
                           │ Worker        │ Farmer
                           │ Accepts       │ Deletes
                           │               │
                           ▼               │
                    ┌──────────────┐       │
                    │   ACCEPTED   │       │
                    │ (Worker Info │       │
                    │   Recorded)  │       │
                    └──────────────┘       │
                                           │
                    ┌──────────────┐       │
                    │   DELETED    │◄──────┘
                    │ (Removed from│
                    │   Database)  │
                    └──────────────┘
```

## 🔐 Authentication Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                   AUTHENTICATION FLOW                            │
└─────────────────────────────────────────────────────────────────┘

LOGIN SCREEN
     │
     ├─► Select User Type
     │   ├─ Farmer
     │   ├─ Consumer
     │   └─ Worker ◄── NEW
     │
     ├─► Enter Phone Number
     │
     └─► Submit
         │
         ├─► User Exists?
         │   ├─ YES → Load User Data
         │   │         └─► Save to SharedPreferences
         │   │             └─► Navigate to Home
         │   │                 ├─ Farmer → Farmer Home
         │   │                 ├─ Consumer → Consumer Home
         │   │                 └─ Worker → Worker Home ◄── NEW
         │   │
         │   └─ NO → Navigate to Signup
         │            └─► Register New User
         │                └─► Navigate to Home
         │
         └─► Keep Me Logged In?
             └─► Save userType to SharedPreferences
```

## 📱 Screen Navigation Map

```
┌─────────────────────────────────────────────────────────────────┐
│                   SCREEN NAVIGATION                              │
└─────────────────────────────────────────────────────────────────┘

                    ┌──────────────┐
                    │ Login Screen │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
      ┌──────────┐  ┌──────────┐  ┌──────────┐
      │  Farmer  │  │ Consumer │  │  Worker  │
      │   Home   │  │   Home   │  │   Home   │ ◄── NEW
      └────┬─────┘  └──────────┘  └────┬─────┘
           │                            │
           │                            ├─► Available Jobs Tab
           │                            │   └─► Job Cards
           │                            │       ├─► Call Farmer
           │                            │       └─► Accept Job
           │                            │
           │                            └─► My Jobs Tab
           │                                └─► Accepted Jobs
           │
           └─► Hire Worker ◄── NEW
               └─► Post Job Form
               └─► My Posted Jobs
                   ├─► View Status
                   └─► Delete Job
```

## 🔄 Real-time Updates Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                   REAL-TIME UPDATES                              │
└─────────────────────────────────────────────────────────────────┘

FARMER POSTS JOB
     │
     ├─► Job saved to MongoDB
     │   └─► Status: Pending
     │
     └─► Available to all Workers
         └─► Pull-to-refresh to see

WORKER ACCEPTS JOB
     │
     ├─► Job updated in MongoDB
     │   ├─► Status: Accepted
     │   ├─► workerId: [Worker ID]
     │   └─► workerName: [Worker Name]
     │
     ├─► Removed from "Available Jobs"
     │   └─► (For all workers)
     │
     ├─► Added to "My Jobs"
     │   └─► (For accepting worker)
     │
     └─► Updated in Farmer's list
         └─► Shows worker info
         └─► Cannot be deleted

FARMER DELETES JOB
     │
     ├─► Job removed from MongoDB
     │
     ├─► Removed from "Available Jobs"
     │   └─► (For all workers)
     │
     └─► Removed from Farmer's list
```

## 📞 Communication Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                   COMMUNICATION FLOW                             │
└─────────────────────────────────────────────────────────────────┘

WORKER CALLS FARMER
     │
     ├─► Click "Call Farmer" button
     │
     ├─► url_launcher package
     │   └─► tel:[farmerPhone]
     │
     ├─► Phone dialer opens
     │   └─► Pre-filled with farmer's number
     │
     └─► Worker makes call
         └─► Discuss job details
         └─► Coordinate work

FARMER'S PHONE NUMBER
     │
     ├─► Stored in WorkRequest
     │   └─► farmerPhone field
     │
     ├─► Visible to workers
     │   └─► Only for jobs they can see
     │
     └─► Used for direct communication
         └─► No in-app messaging needed
```

---

## 📝 Notes

- All flows are designed to be simple and intuitive
- Minimal steps required for core actions
- Real-time updates via pull-to-refresh
- Direct communication via phone calls
- Clear visual feedback for all actions
- Error handling at every step

---

**Visual Flow Complete! 🎨**

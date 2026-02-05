const express = require('express');
const router = express.Router();
const WorkRequest = require('../models/WorkRequest');

// Create a new work request (Farmer posts a job)
router.post('/create', async (req, res) => {
  try {
    const { farmerId, farmerName, farmerPhone, workType, paymentAmount, description } = req.body;

    // Validate required fields
    if (!farmerId || !farmerName || !farmerPhone || !workType || !paymentAmount || !description) {
      return res.status(400).json({
        success: false,
        message: 'All fields are required',
      });
    }

    // Create new work request
    const workRequest = new WorkRequest({
      farmerId,
      farmerName,
      farmerPhone,
      workType,
      paymentAmount,
      description,
      status: 'Pending',
    });

    await workRequest.save();

    res.status(201).json({
      success: true,
      message: 'Work request created successfully',
      workRequest,
    });
  } catch (error) {
    console.error('Error creating work request:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create work request',
      error: error.message,
    });
  }
});

// Get all open work requests (for workers to view)
router.get('/open', async (req, res) => {
  try {
    const workRequests = await WorkRequest.find({ status: 'Pending' })
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      workRequests,
    });
  } catch (error) {
    console.error('Error fetching work requests:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch work requests',
      error: error.message,
    });
  }
});

// Get work requests by farmer ID
router.get('/farmer/:farmerId', async (req, res) => {
  try {
    const { farmerId } = req.params;
    const workRequests = await WorkRequest.find({ farmerId })
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      workRequests,
    });
  } catch (error) {
    console.error('Error fetching farmer work requests:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch work requests',
      error: error.message,
    });
  }
});

// Get work requests accepted by a worker
router.get('/worker/:workerId', async (req, res) => {
  try {
    const { workerId } = req.params;
    const workRequests = await WorkRequest.find({ workerId, status: 'Accepted' })
      .sort({ acceptedAt: -1 });

    res.json({
      success: true,
      workRequests,
    });
  } catch (error) {
    console.error('Error fetching worker jobs:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch worker jobs',
      error: error.message,
    });
  }
});

// Accept a work request (Worker accepts a job)
router.put('/accept/:requestId', async (req, res) => {
  try {
    const { requestId } = req.params;
    const { workerId, workerName } = req.body;

    if (!workerId || !workerName) {
      return res.status(400).json({
        success: false,
        message: 'Worker ID and name are required',
      });
    }

    const workRequest = await WorkRequest.findById(requestId);

    if (!workRequest) {
      return res.status(404).json({
        success: false,
        message: 'Work request not found',
      });
    }

    if (workRequest.status === 'Accepted') {
      return res.status(400).json({
        success: false,
        message: 'This job has already been accepted',
      });
    }

    // Update work request
    workRequest.status = 'Accepted';
    workRequest.workerId = workerId;
    workRequest.workerName = workerName;
    workRequest.acceptedAt = new Date();

    await workRequest.save();

    res.json({
      success: true,
      message: 'Work request accepted successfully',
      workRequest,
    });
  } catch (error) {
    console.error('Error accepting work request:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to accept work request',
      error: error.message,
    });
  }
});

// Delete a work request (Farmer cancels a job)
router.delete('/:requestId', async (req, res) => {
  try {
    const { requestId } = req.params;
    const workRequest = await WorkRequest.findByIdAndDelete(requestId);

    if (!workRequest) {
      return res.status(404).json({
        success: false,
        message: 'Work request not found',
      });
    }

    res.json({
      success: true,
      message: 'Work request deleted successfully',
    });
  } catch (error) {
    console.error('Error deleting work request:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete work request',
      error: error.message,
    });
  }
});

module.exports = router;

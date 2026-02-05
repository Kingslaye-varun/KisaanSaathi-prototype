const express = require('express');
const router = express.Router();
const Worker = require('../models/Worker');
const cloudinary = require('../utils/cloudinary');
const multer = require('multer');

// Configure multer for memory storage
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// Register a new worker
router.post('/register', upload.single('profileImage'), async (req, res) => {
  try {
    const { name, phoneNumber, language } = req.body;

    // Check if worker already exists
    const existingWorker = await Worker.findOne({ phoneNumber });
    if (existingWorker) {
      return res.status(400).json({
        success: false,
        message: 'Worker with this phone number already exists',
      });
    }

    // Upload profile image to Cloudinary if provided
    let imageData = {};
    if (req.file) {
      try {
        // Convert buffer to base64
        const b64 = Buffer.from(req.file.buffer).toString('base64');
        const dataURI = `data:${req.file.mimetype};base64,${b64}`;

        const uploadResponse = await cloudinary.uploader.upload(dataURI, {
          folder: 'kisaansaathi/workers',
          transformation: [
            { width: 400, height: 400, crop: 'fill' },
            { quality: 'auto' }
          ]
        });
        imageData = {
          url: uploadResponse.secure_url,
          publicId: uploadResponse.public_id,
        };
      } catch (uploadError) {
        console.error('Error uploading image to Cloudinary:', uploadError);
        // Continue without image
      }
    }

    // Create new worker
    const worker = new Worker({
      name,
      phoneNumber,
      language: language || 'English',
      profileImage: imageData,
    });

    await worker.save();

    res.status(201).json({
      success: true,
      message: 'Worker registered successfully',
      worker,
    });
  } catch (error) {
    console.error('Error registering worker:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to register worker',
      error: error.message,
    });
  }
});

// Get worker by phone number
router.get('/phone/:phoneNumber', async (req, res) => {
  try {
    const { phoneNumber } = req.params;
    const worker = await Worker.findOne({ phoneNumber });

    if (!worker) {
      return res.status(404).json({
        success: false,
        message: 'Worker not found',
      });
    }

    res.json({
      success: true,
      worker,
    });
  } catch (error) {
    console.error('Error fetching worker:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch worker',
      error: error.message,
    });
  }
});

// Get worker by ID
router.get('/:id', async (req, res) => {
  try {
    const worker = await Worker.findById(req.params.id);

    if (!worker) {
      return res.status(404).json({
        success: false,
        message: 'Worker not found',
      });
    }

    res.json({
      success: true,
      worker,
    });
  } catch (error) {
    console.error('Error fetching worker:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch worker',
      error: error.message,
    });
  }
});

module.exports = router;

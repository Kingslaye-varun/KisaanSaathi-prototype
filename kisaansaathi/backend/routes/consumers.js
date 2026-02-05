const express = require('express');
const router = express.Router();
const Consumer = require('../models/Consumer');
const cloudinary = require('../utils/cloudinary');
const multer = require('multer');

// Configure multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// Register a new consumer
router.post('/register', upload.single('profileImage'), async (req, res) => {
  try {
    const { name, phoneNumber, language } = req.body;

    // Check if consumer already exists
    let consumer = await Consumer.findOne({ phoneNumber });
    if (consumer) {
      return res.status(400).json({
        success: false,
        message: 'Consumer with this phone number already exists',
      });
    }

    // Upload profile image to Cloudinary if provided
    let profileImage = null;
    if (req.file) {
      const b64 = Buffer.from(req.file.buffer).toString('base64');
      const dataURI = `data:${req.file.mimetype};base64,${b64}`;
      const result = await cloudinary.uploader.upload(dataURI, {
        folder: 'kisaansaathi/consumers',
        resource_type: 'auto',
      });
      profileImage = {
        url: result.secure_url,
        publicId: result.public_id,
      };
    }

    // Create new consumer
    consumer = new Consumer({
      name,
      phoneNumber,
      language: language || 'English',
      profileImage,
    });

    await consumer.save();

    res.status(201).json({
      success: true,
      message: 'Consumer registered successfully',
      data: consumer,
      token: `consumer_${consumer._id}`, // Simple token for now
    });
  } catch (error) {
    console.error('Error registering consumer:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while registering consumer',
      error: error.message,
    });
  }
});

// Get consumer by phone number
router.get('/:phoneNumber', async (req, res) => {
  try {
    const { phoneNumber } = req.params;

    const consumer = await Consumer.findOne({ phoneNumber });

    if (!consumer) {
      return res.status(404).json({
        success: false,
        message: 'Consumer not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Consumer retrieved successfully',
      data: consumer,
    });
  } catch (error) {
    console.error('Error getting consumer:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while retrieving consumer',
      error: error.message,
    });
  }
});

// Update consumer profile
router.put('/:phoneNumber', upload.single('profileImage'), async (req, res) => {
  try {
    const { phoneNumber } = req.params;
    const { name, language } = req.body;

    const consumer = await Consumer.findOne({ phoneNumber });

    if (!consumer) {
      return res.status(404).json({
        success: false,
        message: 'Consumer not found',
      });
    }

    // Update fields
    if (name) consumer.name = name;
    if (language) consumer.language = language;

    // Update profile image if provided
    if (req.file) {
      // Delete old image from Cloudinary if exists
      if (consumer.profileImage && consumer.profileImage.publicId) {
        await cloudinary.uploader.destroy(consumer.profileImage.publicId);
      }

      const b64 = Buffer.from(req.file.buffer).toString('base64');
      const dataURI = `data:${req.file.mimetype};base64,${b64}`;
      const result = await cloudinary.uploader.upload(dataURI, {
        folder: 'kisaansaathi/consumers',
        resource_type: 'auto',
      });

      consumer.profileImage = {
        url: result.secure_url,
        publicId: result.public_id,
      };
    }

    await consumer.save();

    res.status(200).json({
      success: true,
      message: 'Consumer profile updated successfully',
      data: consumer,
    });
  } catch (error) {
    console.error('Error updating consumer:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while updating consumer',
      error: error.message,
    });
  }
});

module.exports = router;

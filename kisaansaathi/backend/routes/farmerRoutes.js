const express = require('express');
const router = express.Router();
const Farmer = require('../models/Farmer');
const cloudinary = require('../utils/cloudinary');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });

// Register a new farmer
router.post('/register', upload.single('profileImage'), async (req, res) => {
  try {
    const { name, phoneNumber, language } = req.body;
    
    // Check if farmer already exists
    const existingFarmer = await Farmer.findOne({ phoneNumber });
    if (existingFarmer) {
      return res.status(200).json({ 
        success: true, 
        message: 'Farmer already registered',
        data: existingFarmer
      });
    }
    
    let profileImageData = {
      public_id: '',
      url: 'https://res.cloudinary.com/demo/image/upload/v1580125211/samples/people/farmer.jpg'
    };
    
    // Upload image to cloudinary if provided
    if (req.file) {
      // Convert buffer to base64 string for Cloudinary
      const b64 = Buffer.from(req.file.buffer).toString('base64');
      const dataURI = `data:${req.file.mimetype};base64,${b64}`;
      
      const result = await cloudinary.uploader.upload(dataURI, {
        folder: 'kisaansaathi/farmers',
        width: 300,
        crop: "scale"
      });
      
      profileImageData = {
        public_id: result.public_id,
        url: result.secure_url
      };
    }
    
    // Create new farmer
    const farmer = await Farmer.create({
      name,
      phoneNumber,
      language,
      profileImage: profileImageData
    });
    
    res.status(201).json({
      success: true,
      message: 'Farmer registered successfully',
      data: farmer
    });
    
  } catch (error) {
    console.error('Error registering farmer:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to register farmer',
      error: error.message
    });
  }
});

// Get farmer by phone number
router.get('/:phoneNumber', async (req, res) => {
  try {
    const farmer = await Farmer.findOne({ phoneNumber: req.params.phoneNumber });
    
    if (!farmer) {
      return res.status(404).json({
        success: false,
        message: 'Farmer not found'
      });
    }
    
    res.status(200).json({
      success: true,
      data: farmer
    });
    
  } catch (error) {
    console.error('Error fetching farmer:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch farmer',
      error: error.message
    });
  }
});

// Update farmer profile
router.put('/:id', upload.single('profileImage'), async (req, res) => {
  try {
    const { name, language } = req.body;
    const farmerId = req.params.id;
    
    const updateData = {
      name,
      language
    };
    
    // Upload new image if provided
    if (req.file) {
      // Convert buffer to base64 string for Cloudinary
      const b64 = Buffer.from(req.file.buffer).toString('base64');
      const dataURI = `data:${req.file.mimetype};base64,${b64}`;
      
      const result = await cloudinary.uploader.upload(dataURI, {
        folder: 'kisaansaathi/farmers',
        width: 300,
        crop: "scale"
      });
      
      updateData.profileImage = {
        public_id: result.public_id,
        url: result.secure_url
      };
      
      // Delete old image if exists
      const farmer = await Farmer.findById(farmerId);
      if (farmer.profileImage && farmer.profileImage.public_id) {
        await cloudinary.uploader.destroy(farmer.profileImage.public_id);
      }
    }
    
    const updatedFarmer = await Farmer.findByIdAndUpdate(
      farmerId,
      updateData,
      { new: true, runValidators: true }
    );
    
    if (!updatedFarmer) {
      return res.status(404).json({
        success: false,
        message: 'Farmer not found'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Farmer profile updated successfully',
      data: updatedFarmer
    });
    
  } catch (error) {
    console.error('Error updating farmer profile:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update farmer profile',
      error: error.message
    });
  }
});

module.exports = router;
const mongoose = require('mongoose');

const farmerSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true
  },
  phoneNumber: {
    type: String,
    required: [true, 'Phone number is required'],
    unique: true,
    trim: true,
    validate: {
      validator: function(v) {
        return /^\d{10}$/.test(v);
      },
      message: props => `${props.value} is not a valid phone number! Must be 10 digits.`
    }
  },
  farmerId: {
    type: String,
    trim: true,
    sparse: true,
    validate: {
      validator: function(v) {
        // If not provided, skip validation
        if (!v) return true;
        // Format: KL + 11 digits + 1 checksum digit
        return /^KL\d{12}$/.test(v);
      },
      message: props => `${props.value} is not a valid Farmer ID! Must be in format KL + 12 digits.`
    }
  },
  isVerified: {
    type: Boolean,
    default: false
  },
  language: {
    type: String,
    required: [true, 'Language preference is required'],
    default: 'English'
  },
  profileImage: {
    public_id: String,
    url: {
      type: String,
      default: 'https://res.cloudinary.com/demo/image/upload/v1580125211/samples/people/farmer.jpg'
    }
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Farmer', farmerSchema);
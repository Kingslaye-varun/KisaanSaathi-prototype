const mongoose = require('mongoose');

const consumerSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  phoneNumber: {
    type: String,
    required: true,
    unique: true,
    trim: true,
  },
  language: {
    type: String,
    default: 'English',
  },
  profileImage: {
    url: String,
    publicId: String,
  },
}, {
  timestamps: true,
});

// Index for faster phone number lookups
consumerSchema.index({ phoneNumber: 1 });

module.exports = mongoose.model('Consumer', consumerSchema);

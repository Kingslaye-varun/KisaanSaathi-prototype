const mongoose = require('mongoose');

const workerSchema = new mongoose.Schema({
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
    validate: {
      validator: function(v) {
        return /^\d{10}$/.test(v);
      },
      message: props => `${props.value} is not a valid phone number! Must be 10 digits.`
    }
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
workerSchema.index({ phoneNumber: 1 });

module.exports = mongoose.model('Worker', workerSchema);

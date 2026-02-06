const mongoose = require('mongoose');

const workRequestSchema = new mongoose.Schema({
  farmerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Farmer',
    required: true,
  },
  farmerName: {
    type: String,
    required: true,
  },
  farmerPhone: {
    type: String,
    required: true,
  },
  workType: {
    type: String,
    required: true,
    trim: true,
  },
  paymentAmount: {
    type: Number,
    required: true,
    min: 0,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  status: {
    type: String,
    enum: ['Pending', 'Accepted'],
    default: 'Pending',
  },
  workerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Worker',
  },
  workerName: {
    type: String,
  },
  acceptedAt: {
    type: Date,
  },
}, {
  timestamps: true,
});

// Index for faster queries
workRequestSchema.index({ farmerId: 1 });
workRequestSchema.index({ workerId: 1 });
workRequestSchema.index({ status: 1 });

module.exports = mongoose.model('WorkRequest', workRequestSchema);

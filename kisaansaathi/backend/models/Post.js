const mongoose = require('mongoose');

const PostSchema = new mongoose.Schema({
  // Support both author (farmer app) and user (other app)
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Farmer'
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  // Username for other app compatibility
  username: {
    type: String
  },
  userCategory: {
    type: String,
    default: 'Farmers'
  },
  // Support both content (farmer app) and caption (other app)
  content: {
    type: String,
    trim: true
  },
  caption: {
    type: String,
    trim: true
  },
  imageUrl: {
    type: String
  },
  // Support both cloudinaryId and imagePublicId
  cloudinaryId: {
    type: String
  },
  imagePublicId: {
    type: String
  },
  tags: [{
    type: String,
    enum: ['success_story', 'question', 'pest_control', 'harvest', 'market_prices', 'weather', 'equipment', 'seeds', 'fertilizer', 'general'],
    default: 'general'
  }],
  likes: [{
    type: mongoose.Schema.Types.ObjectId,
    refPath: 'likeModel'
  }],
  likeModel: {
    type: String,
    enum: ['Farmer', 'User'],
    default: 'Farmer'
  },
  comments: [{
    // Support both author and user in comments
    author: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Farmer'
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    username: {
      type: String
    },
    // Support both content and text in comments
    content: {
      type: String,
      trim: true
    },
    text: {
      type: String,
      trim: true
    },
    createdAt: {
      type: Date,
      default: Date.now
    }
  }],
  createdAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

// Virtual for like count
PostSchema.virtual('likeCount').get(function() {
  return this.likes.length;
});

// Virtual for comment count
PostSchema.virtual('commentCount').get(function() {
  return this.comments.length;
});

// Set virtuals to true when converting to JSON
PostSchema.set('toJSON', { virtuals: true });
PostSchema.set('toObject', { virtuals: true });

module.exports = mongoose.model('Post', PostSchema);
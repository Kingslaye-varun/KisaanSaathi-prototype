const express = require('express');
const router = express.Router();
const Post = require('../models/Post');
const multer = require('multer');
const cloudinary = require('../utils/cloudinary');

// Configure multer for memory storage
const storage = multer.memoryStorage();
const upload = multer({ storage });

// Get all posts (with pagination and sorting by latest)
router.get('/', async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;
    const tag = req.query.tag;

    let query = {};
    if (tag) {
      query.tags = tag;
    }

    const posts = await Post.find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .populate('author', 'name phoneNumber profileImage')
      .populate('comments.author', 'name phoneNumber profileImage');

    const total = await Post.countDocuments(query);

    res.json({
      posts,
      totalPages: Math.ceil(total / limit),
      currentPage: page
    });
  } catch (error) {
    console.error('Error fetching posts:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Create a new post
router.post('/', upload.single('image'), async (req, res) => {
  try {
    const { content, authorId, tags } = req.body;
    
    if (!content || !authorId) {
      return res.status(400).json({ message: 'Content and author are required' });
    }

    const postData = {
      content,
      author: authorId,
      tags: tags ? JSON.parse(tags) : ['general']
    };

    // Upload image to Cloudinary if provided
    if (req.file) {
      // Convert buffer to base64 data URI
      const b64 = Buffer.from(req.file.buffer).toString('base64');
      const dataURI = `data:${req.file.mimetype};base64,${b64}`;
      
      const result = await cloudinary.uploader.upload(dataURI, {
        folder: 'kisaansaathi_posts',
      });

      postData.imageUrl = result.secure_url;
      postData.cloudinaryId = result.public_id;
    }

    const post = new Post(postData);
    await post.save();

    // Populate author details before sending response
    await post.populate('author', 'name phoneNumber profileImage');
    
    res.status(201).json(post);
  } catch (error) {
    console.error('Error creating post:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get a specific post by ID
router.get('/:id', async (req, res) => {
  try {
    const post = await Post.findById(req.params.id)
      .populate('author', 'name phoneNumber profileImage')
      .populate('comments.author', 'name phoneNumber profileImage');
    
    if (!post) {
      return res.status(404).json({ message: 'Post not found' });
    }
    
    res.json(post);
  } catch (error) {
    console.error('Error fetching post:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Like/unlike a post
router.post('/:id/like', async (req, res) => {
  try {
    const { farmerId } = req.body;
    
    if (!farmerId) {
      return res.status(400).json({ message: 'Farmer ID is required' });
    }
    
    const post = await Post.findById(req.params.id);
    
    if (!post) {
      return res.status(404).json({ message: 'Post not found' });
    }
    
    // Check if farmer already liked the post
    const alreadyLiked = post.likes.includes(farmerId);
    
    if (alreadyLiked) {
      // Unlike the post
      post.likes = post.likes.filter(id => id.toString() !== farmerId);
    } else {
      // Like the post
      post.likes.push(farmerId);
    }
    
    await post.save();
    
    res.json({ likes: post.likes, likeCount: post.likes.length });
  } catch (error) {
    console.error('Error liking/unliking post:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Add a comment to a post
router.post('/:id/comment', async (req, res) => {
  try {
    const { content, authorId } = req.body;
    
    if (!content || !authorId) {
      return res.status(400).json({ message: 'Content and author are required' });
    }
    
    const post = await Post.findById(req.params.id);
    
    if (!post) {
      return res.status(404).json({ message: 'Post not found' });
    }
    
    post.comments.push({
      content,
      author: authorId
    });
    
    await post.save();
    
    // Get the newly added comment with populated author
    const newComment = post.comments[post.comments.length - 1];
    await Post.populate(post, {
      path: 'comments.author',
      select: 'name phoneNumber profileImage',
      match: { _id: newComment.author }
    });
    
    res.status(201).json(newComment);
  } catch (error) {
    console.error('Error adding comment:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get posts by a specific farmer
router.get('/farmer/:farmerId', async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;
    
    const posts = await Post.find({ author: req.params.farmerId })
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .populate('author', 'name phoneNumber profileImage')
      .populate('comments.author', 'name phoneNumber profileImage');
    
    const total = await Post.countDocuments({ author: req.params.farmerId });
    
    res.json({
      posts,
      totalPages: Math.ceil(total / limit),
      currentPage: page
    });
  } catch (error) {
    console.error('Error fetching farmer posts:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Delete a post
router.delete('/:id', async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    
    if (!post) {
      return res.status(404).json({ message: 'Post not found' });
    }
    
    // Delete image from Cloudinary if exists
    if (post.cloudinaryId) {
      await cloudinary.uploader.destroy(post.cloudinaryId);
    }
    
    await post.deleteOne();
    
    res.json({ message: 'Post deleted successfully' });
  } catch (error) {
    console.error('Error deleting post:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
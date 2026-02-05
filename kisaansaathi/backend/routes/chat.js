const express = require('express');
const router = express.Router();
const Message = require('../models/Message');
const Farmer = require('../models/Farmer');
const Consumer = require('../models/Consumer');

// Get all conversations for a user
router.get('/conversations/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    console.log(`🔵 Fetching conversations for user: ${userId}`);

    // Find all messages where user is sender or receiver
    const messages = await Message.find({
      $or: [{ sender: userId }, { receiver: userId }],
    })
      .sort({ createdAt: -1 })
      .populate('sender', 'name profileImage')
      .populate('receiver', 'name profileImage');

    // Group messages by conversation partner
    const conversationsMap = new Map();

    for (const message of messages) {
      const otherUserId = message.sender._id.toString() === userId
        ? message.receiver._id.toString()
        : message.sender._id.toString();

      if (!conversationsMap.has(otherUserId)) {
        const otherUser = message.sender._id.toString() === userId
          ? message.receiver
          : message.sender;

        // Determine user type
        let userType = 'farmer';
        const isFarmer = await Farmer.findById(otherUserId);
        if (!isFarmer) {
          userType = 'consumer';
        }

        conversationsMap.set(otherUserId, {
          otherUser: {
            _id: otherUser._id,
            name: otherUser.name,
            profileImage: otherUser.profileImage,
            userType,
          },
          lastMessage: {
            content: message.content,
            createdAt: message.createdAt,
            sender: message.sender._id,
          },
          unreadCount: 0,
        });
      }
    }

    // Count unread messages for each conversation
    for (const [otherUserId, conversation] of conversationsMap) {
      const unreadCount = await Message.countDocuments({
        sender: otherUserId,
        receiver: userId,
        read: false,
      });
      conversation.unreadCount = unreadCount;
    }

    const conversations = Array.from(conversationsMap.values());
    console.log(`✅ Found ${conversations.length} conversations`);

    res.status(200).json({
      success: true,
      conversations,
    });
  } catch (error) {
    console.error('❌ Error fetching conversations:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching conversations',
      error: error.message,
    });
  }
});

// Get messages between two users
router.get('/messages/:userId1/:userId2', async (req, res) => {
  try {
    const { userId1, userId2 } = req.params;
    console.log(`🔵 Fetching messages between ${userId1} and ${userId2}`);

    const messages = await Message.find({
      $or: [
        { sender: userId1, receiver: userId2 },
        { sender: userId2, receiver: userId1 },
      ],
    })
      .sort({ createdAt: 1 })
      .populate('sender', 'name profileImage')
      .populate('receiver', 'name profileImage');

    // Mark messages as read
    await Message.updateMany(
      { sender: userId2, receiver: userId1, read: false },
      { read: true }
    );

    console.log(`✅ Found ${messages.length} messages`);

    res.status(200).json({
      success: true,
      messages,
    });
  } catch (error) {
    console.error('❌ Error fetching messages:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching messages',
      error: error.message,
    });
  }
});

// Send a message
router.post('/messages', async (req, res) => {
  try {
    const { sender, receiver, content } = req.body;
    console.log(`🔵 Sending message from ${sender} to ${receiver}`);

    if (!sender || !receiver || !content) {
      return res.status(400).json({
        success: false,
        message: 'Sender, receiver, and content are required',
      });
    }

    // Determine sender and receiver models
    let senderModel = 'Farmer';
    let receiverModel = 'Farmer';

    const senderFarmer = await Farmer.findById(sender);
    if (!senderFarmer) {
      senderModel = 'Consumer';
    }

    const receiverFarmer = await Farmer.findById(receiver);
    if (!receiverFarmer) {
      receiverModel = 'Consumer';
    }

    const message = new Message({
      sender,
      senderModel,
      receiver,
      receiverModel,
      content,
    });

    await message.save();
    await message.populate('sender', 'name profileImage');
    await message.populate('receiver', 'name profileImage');

    console.log(`✅ Message sent successfully`);

    res.status(201).json({
      success: true,
      message,
    });
  } catch (error) {
    console.error('❌ Error sending message:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while sending message',
      error: error.message,
    });
  }
});

// Mark messages as read
router.put('/messages/read', async (req, res) => {
  try {
    const { sender, receiver } = req.body;
    console.log(`🔵 Marking messages as read from ${sender} to ${receiver}`);

    await Message.updateMany(
      { sender, receiver, read: false },
      { read: true }
    );

    console.log(`✅ Messages marked as read`);

    res.status(200).json({
      success: true,
      message: 'Messages marked as read',
    });
  } catch (error) {
    console.error('❌ Error marking messages as read:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while marking messages as read',
      error: error.message,
    });
  }
});

module.exports = router;

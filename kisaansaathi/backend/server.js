require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const farmerRoutes = require('./routes/farmerRoutes');
const postRoutes = require('./routes/postRoutes');
const consumerRoutes = require('./routes/consumers');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('MongoDB connected'))
.catch(err => console.error('MongoDB connection error:', err));

// Routes
app.use('/api/farmers', farmerRoutes);
app.use('/api/posts', postRoutes);
app.use('/api/consumers', consumerRoutes);

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
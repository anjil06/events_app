const path = require('path');
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

// Load .env explicitly from backend directory or cwd
dotenv.config({ path: path.resolve(__dirname, '../.env') });
dotenv.config();

const uploadRoutes = require('./routes/upload');
const { isCloudinaryConfigured } = require('./config/cloudinary');

const app = express();
const PORT = process.env.PORT || 5000;

// Enable CORS for all origins (Flutter Web, Android Emulator, iOS, Desktop)
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Body parser
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Simple request logger
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`[${req.method}] ${req.originalUrl} -> ${res.statusCode} (${duration}ms)`);
  });
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'online',
    app: 'TechCulture API & Cloudinary Service',
    timestamp: new Date().toISOString(),
    cloudinaryConfigured: isCloudinaryConfigured(),
  });
});

app.get('/', (req, res) => {
  res.status(200).json({
    name: 'TechCulture Backend',
    version: '1.0.0',
    endpoints: {
      health: 'GET /health',
      uploadEventImage: 'POST /api/upload/event-image',
      uploadProfileImage: 'POST /api/upload/profile-image',
      deleteImage: 'POST /api/upload/delete',
    },
  });
});

// Mount upload routes
app.use('/api/upload', uploadRoutes);

// 404 Handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: `Route not found: ${req.method} ${req.originalUrl}`,
  });
});

// Centralized error handler
app.use((err, req, res, next) => {
  console.error('API Error:', err);

  if (err.code === 'LIMIT_FILE_SIZE') {
    return res.status(413).json({
      success: false,
      error: 'File size exceeds maximum limit of 10MB.',
    });
  }

  const statusCode = err.status || err.statusCode || 500;
  return res.status(statusCode).json({
    success: false,
    error: err.message || 'Internal Server Error',
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 TechCulture backend listening on http://0.0.0.0:${PORT}`);
  console.log(`📡 Health check: http://localhost:${PORT}/health`);
});

module.exports = app;

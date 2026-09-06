const express = require('express');
const router = express.Router();
const upload = require('../middleware/upload');
const { cloudinary, isCloudinaryConfigured } = require('../config/cloudinary');

/**
 * Helper to upload buffer to Cloudinary using upload_stream
 */
const uploadBufferToCloudinary = (buffer, folder, customPublicId = null) => {
  return new Promise((resolve, reject) => {
    const options = {
      folder,
      resource_type: 'image',
    };

    if (customPublicId) {
      options.public_id = customPublicId;
      options.overwrite = true;
    }

    const stream = cloudinary.uploader.upload_stream(options, (error, result) => {
      if (error) return reject(error);
      resolve(result);
    });

    stream.end(buffer);
  });
};

/**
 * POST /api/upload/event-image
 * Uploads event banner/thumbnail to 'techculture/events'
 */
router.post('/event-image', upload.single('image'), async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'No image file provided in multipart request under field \'image\'',
      });
    }

    const { old_public_id } = req.body;

    // If Cloudinary is not configured yet in .env, return mock payload for testing
    if (!isCloudinaryConfigured()) {
      console.warn('⚠️ Mock upload: Cloudinary credentials not configured. Returning simulated URL.');
      const mockId = 'mock_event_' + Date.now();
      return res.status(200).json({
        success: true,
        isMock: true,
        message: 'Cloudinary credentials not yet set in .env. Mock upload returned.',
        secure_url: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1200&auto=format&fit=crop&q=80',
        public_id: 'techculture/events/' + mockId,
        format: 'jpg',
      });
    }

    // Delete old image if provided
    if (old_public_id && typeof old_public_id === 'string' && old_public_id.startsWith('techculture/')) {
      try {
        await cloudinary.uploader.destroy(old_public_id);
      } catch (delErr) {
        console.warn('Could not delete previous asset:', delErr.message);
      }
    }

    const result = await uploadBufferToCloudinary(req.file.buffer, 'techculture/events');

    return res.status(200).json({
      success: true,
      secure_url: result.secure_url,
      public_id: result.public_id,
      format: result.format,
      width: result.width,
      height: result.height,
      bytes: result.bytes,
    });
  } catch (error) {
    next(error);
  }
});

/**
 * POST /api/upload/profile-image
 * Uploads user avatar to 'techculture/profiles'
 */
router.post('/profile-image', upload.single('image'), async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'No image file provided in multipart request under field \'image\'',
      });
    }

    const { old_public_id } = req.body;

    if (!isCloudinaryConfigured()) {
      console.warn('⚠️ Mock upload: Cloudinary credentials not configured. Returning simulated URL.');
      const mockId = 'mock_profile_' + Date.now();
      return res.status(200).json({
        success: true,
        isMock: true,
        message: 'Cloudinary credentials not yet set in .env. Mock upload returned.',
        secure_url: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
        public_id: 'techculture/profiles/' + mockId,
        format: 'jpg',
      });
    }

    // Delete old image if provided
    if (old_public_id && typeof old_public_id === 'string' && old_public_id.startsWith('techculture/')) {
      try {
        await cloudinary.uploader.destroy(old_public_id);
      } catch (delErr) {
        console.warn('Could not delete previous asset:', delErr.message);
      }
    }

    const result = await uploadBufferToCloudinary(req.file.buffer, 'techculture/profiles');

    return res.status(200).json({
      success: true,
      secure_url: result.secure_url,
      public_id: result.public_id,
      format: result.format,
      width: result.width,
      height: result.height,
      bytes: result.bytes,
    });
  } catch (error) {
    next(error);
  }
});

/**
 * POST /api/upload/delete
 * Deletes an existing image from Cloudinary using public_id
 */
router.post('/delete', async (req, res, next) => {
  try {
    const { public_id } = req.body;
    if (!public_id) {
      return res.status(400).json({
        success: false,
        error: 'public_id is required to delete an image',
      });
    }

    if (!isCloudinaryConfigured()) {
      return res.status(200).json({
        success: true,
        isMock: true,
        message: 'Cloudinary credentials not set. Mock deletion acknowledged.',
      });
    }

    const result = await cloudinary.uploader.destroy(public_id);
    return res.status(200).json({
      success: true,
      result: result.result,
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;

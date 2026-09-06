const multer = require('multer');
const path = require('path');

// Memory storage to process buffer directly without local disk artifacts
const storage = multer.memoryStorage();

// Common photo and image file extensions
const IMAGE_EXTENSIONS = /\.(jpe?g|png|webp|gif|bmp|heic|heif|avif|tiff?|svg|jfif)$/i;

const fileFilter = (req, file, cb) => {
  const mimetype = (file.mimetype || '').toLowerCase();
  const extname = path.extname(file.originalname || '').toLowerCase();

  // Accept if mimetype is any image (including image/jpeg, image/jpg, image/png, image/webp, image/gif, image/heic, etc.)
  // OR if the file extension matches a recognized photo format
  const isImageMime = mimetype.startsWith('image/') || mimetype === 'application/octet-stream';
  const isImageExt = IMAGE_EXTENSIONS.test(extname) || !extname;

  if (isImageMime || isImageExt) {
    cb(null, true);
  } else {
    const error = new Error('Invalid file type. Please upload a valid photo (JPG, JPEG, PNG, WEBP, GIF, HEIC, BMP).');
    error.status = 400;
    cb(error, false);
  }
};

const upload = multer({
  storage,
  limits: {
    fileSize: 25 * 1024 * 1024, // 25MB limit for modern high-resolution mobile photos
  },
  fileFilter,
});

module.exports = upload;

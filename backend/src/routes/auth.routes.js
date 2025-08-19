const express  = require('express');
const { registerUser, loginUser, refreshToken } = require('../controllers/auth.controller');
const { upload } = require('../utils/multer');
const router = express.Router();

router.post('/register', upload.single('file'), registerUser);
router.post('/login', loginUser);
router.post('/refreshToken', refreshToken);

module.exports = router;
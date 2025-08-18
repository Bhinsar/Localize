const express  = require('express');
const { registerUser, loginUser } = require('../controllers/auth.controller');
const { upload } = require('../utils/multer');
const router = express.Router();

router.post('/register', upload.single('file'), registerUser);
router.post('/login', loginUser);

module.exports = router;
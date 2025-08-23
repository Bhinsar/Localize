const express  = require('express');
const { registerUser, loginUser, refreshToken, signInWithGoogle } = require('../controllers/auth.controller');
const { upload } = require('../utils/multer');
const router = express.Router();

router.post('/register',  registerUser);
router.post('/login', loginUser);
router.post('/refreshToken', refreshToken);
router.post('/google', signInWithGoogle);

module.exports = router;
const express  = require('express');
const { registerUser, loginUser, refreshToken, signInWithGoogle, addNumberAndRole, getUserProfile } = require('../controllers/auth.controller');
const { upload } = require('../utils/multer');
const { authCheck } = require('../middleware/auth.middleware');
const router = express.Router();

router.post('/register',  registerUser);
router.post('/login', loginUser);
router.post('/refreshToken', refreshToken);
router.post('/google', signInWithGoogle);
router.post('/addNumberAndRole', authCheck, addNumberAndRole);

router.get("/get/profile", authCheck, getUserProfile);

module.exports = router;
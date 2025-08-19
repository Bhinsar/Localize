const express = require('express');
const { registerProvider } = require('../controllers/provider.controller');
const { authCheck } = require('../middleware/auth.middleware');
const routes = express.Router();

routes.post("/register/provider", authCheck, registerProvider);

module.exports = routes;
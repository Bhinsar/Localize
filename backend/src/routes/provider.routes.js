const express = require('express');
const { registerProvider, getProviderToUser } = require('../controllers/provider.controller');
const { authCheck } = require('../middleware/auth.middleware');
const routes = express.Router();

routes.post("/register/provider", authCheck, registerProvider);
routes.get("/get/providers", authCheck, getProviderToUser);

module.exports = routes;
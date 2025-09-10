const express = require('express');
const { registerProvider, getProviderToUser, getProviderByID } = require('../controllers/provider.controller');
const { authCheck } = require('../middleware/auth.middleware');
const routes = express.Router();

routes.post("/register/provider", authCheck, registerProvider);
routes.get("/get/providers", authCheck, getProviderToUser);
routes.get("/get/providers/:id", authCheck, getProviderByID);

module.exports = routes;
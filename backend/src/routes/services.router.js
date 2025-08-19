const express = require('express');
const { addServices, getServices } = require('../controllers/services.controller');
const routes = express.Router();

routes.post("/add/services", addServices);
routes.get("/get/services", getServices);

module.exports = routes;
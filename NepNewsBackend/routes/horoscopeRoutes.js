// routes.js or routes/horoscopeRoutes.js
const express = require("express");
const { getHoroscope } = require("../controllers/horoscopeController");

const router = express.Router();

// Define the route for generating horoscopes
router.get("/horoscope/:sign/:period", getHoroscope);

module.exports = router;

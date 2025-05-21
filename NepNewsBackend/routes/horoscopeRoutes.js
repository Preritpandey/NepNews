const express = require("express");
const router = express.Router();
const { getHoroscope } = require("../controllers/horoscopeController");

router.get("/test", (req, res) => {
  res.send("Horoscope test route is working");
});

// Use the controller for real horoscope fetching
router.get("/:sign/:period", getHoroscope);

module.exports = router;

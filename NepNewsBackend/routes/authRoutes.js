// routes/authRoutes.js
const express = require("express");
const router = express.Router();
const passport = require("passport");

const { register, login } = require("../controllers/authController");

// POST /api/auth/register
router.post("/register", register);
// POST /api/auth/login
router.post("/login", login);

// Google Login
router.get(
  "/google",
  passport.authenticate("google", { scope: ["profile", "email"] })
);

// Callback
router.get(
  "/google/callback",
  passport.authenticate("google", { failureRedirect: "/login" }),
  (req, res) => {
    // Successful login
    res.redirect("/dashboard"); // redirect as needed
  }
);

module.exports = router;

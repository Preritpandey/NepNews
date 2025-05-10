// routes/userRoutes.js
const express = require("express");
const router = express.Router();
const auth = require("../middlewares/authMiddleware");
const {
  getAllUsers,
  updateUserRole,
  deleteUser,
  createUser,
} = require("../controllers/userController");

// Get all users (Admin only)
router.get("/", auth, getAllUsers);

// Update user role (Admin only)
router.put("/:userId/role", auth, updateUserRole);

// Delete a user (Admin only)
router.delete("/:userId", auth, deleteUser);

// Create a new user (Admin only)
router.post("/", auth, createUser);

module.exports = router;

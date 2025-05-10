// controllers/userController.js
const User = require("../models/userModel");
const bcrypt = require("bcrypt");

// Get all users (Admin only)
exports.getAllUsers = async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ msg: "Access denied" });
    }

    const users = await User.find().select("-password"); // Exclude password
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

// Update user role (Admin only)
exports.updateUserRole = async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ msg: "Access denied" });
    }

    const { userId } = req.params;
    const { newRole } = req.body;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ msg: "User not found" });

    user.role = newRole;
    await user.save();

    res.json({ msg: "User role updated", user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

// Delete a user (Admin only)
exports.deleteUser = async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ msg: "Access denied" });
    }

    const { userId } = req.params;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    await user.remove();
    res.json({ msg: "User deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

// Create a new user (Admin only)
exports.createUser = async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ msg: "Access denied" });
    }

    const { name, email, password, role } = req.body;

    // Validate role
    if (!["author", "editor"].includes(role)) {
      return res.status(400).json({ msg: "Invalid role. Must be 'author' or 'editor'." });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: "User already exists" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const newUser = new User({
      name,
      email,
      password: hashedPassword,
      role,
    });

    await newUser.save();
    res.status(201).json({ msg: "User created successfully", user: newUser });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

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

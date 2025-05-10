const express = require("express");
const router = express.Router();
const auth = require("../middlewares/authMiddleware");
const { getAllUsers, updateUserRole, deleteUser, createUser } = require("../controllers/userController");

// Ensure the functions are correctly imported
console.log("auth type:", typeof auth);  // Should print "function"
console.log("getAllUsers type:", typeof getAllUsers);  // Should print "function"

// Get all users (Admin only)
router.get("/", auth, getAllUsers);

// Update user role (Admin only)
router.put("/:email/role", auth, updateUserRole);

// Delete a user (Admin only)
router.delete("/:email", auth, deleteUser);

// Create a new user (Admin only)
router.post("/", auth, createUser);

module.exports = router;

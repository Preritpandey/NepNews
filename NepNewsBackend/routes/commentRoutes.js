// routes/commentRoutes.js
const express = require("express");
const router = express.Router();
const auth = require("../middlewares/authMiddleware");
const {
  addComment,
  getCommentsByArticle,
  deleteComment,
} = require("../controllers/commentController");

// Add a comment to an article
router.post("/:articleId", auth, addComment);

// Get all comments for a specific article
router.get("/:articleId", getCommentsByArticle);

// Delete a comment (Admin or comment owner only)
router.delete("/:commentId", auth, deleteComment);

module.exports = router;

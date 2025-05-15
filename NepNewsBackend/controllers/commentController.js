// controllers/commentController.js
const { body, validationResult } = require("express-validator");
const Comment = require("../models/commentModel");
const Article = require("../models/articleModel");

// Add a comment to an article
exports.addComment = [
  // 1. validation
  body("text")
    .trim()
    .notEmpty().withMessage("Comment text is required")
    .isString().withMessage("Comment text must be a string"),

  // 2. controller
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { articleId } = req.params;
    const { text }      = req.body;

    try {
      // make sure the article exists
      const article = await Article.findById(articleId);
      if (!article) {
        return res.status(404).json({ message: "Article not found" });
      }

      // create the comment
      const comment = await Comment.create({
        text,
        article: articleId,
        user:   req.user.userId   // comes from authMiddleware
      });

      return res.status(201).json({ message: "Comment added", comment });
    } catch (err) {
      console.error("Error in addComment:", err);
      return res.status(500).json({ message: "Server error" });
    }
  }
];

// Get all comments for a specific article
exports.getCommentsByArticle = async (req, res) => {
  try {
    const { articleId } = req.params;

    const comments = await Comment.find({ article: articleId }).populate("user", "name");
    res.status(200).json({ comments });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Delete a comment
exports.deleteComment = async (req, res) => {
  try {
    const { commentId } = req.params;

    const comment = await Comment.findById(commentId);
    if (!comment) {
      return res.status(404).json({ message: "Comment not found" });
    }

    // Check if the user is the owner of the comment or an admin
    if (comment.user.toString() !== req.user.userId && req.user.role !== "admin") {
      return res.status(403).json({ message: "Access denied" });
    }

    await comment.remove();
    res.status(200).json({ message: "Comment deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// routes/articleRoutes.js
const express = require("express");
const router = express.Router();
const auth = require("../middlewares/authMiddleware");
const uploads = require("../config/multer");
const {
  createArticle,
  publishArticle,
  getArticles,
  getDraftedArticles,
  editDraftedArticle,
} = require("../controllers/articleController");
const Article = require("../models/articleModel");

const updatePublishedArticle = async (req, res) => {
  try {
    const { articleId } = req.params;
    const { title, content } = req.body;

    // Find the article
    const article = await Article.findById(articleId);
    if (!article) {
      return res.status(404).json({ message: "Article not found" });
    }

    // Check if the user is an editor
    if (req.user.role === "editor") {
      // Allow only title and content to be updated
      article.title = title || article.title;
      article.content = content || article.content;
    } else {
      // For other roles, allow full updates
      Object.assign(article, req.body);
    }

    // Save the updated article
    await article.save();
    res.status(200).json({ message: "Article updated successfully", article });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

router.put("/admin-update/:articleId", auth, uploads.single("image"), updatePublishedArticle);

// Fetch all drafted articles (Editor only)
router.get("/editor/drafts", auth, getDraftedArticles);

// Edit a drafted article (Editor only)
router.put("/editor/drafts/:articleId", auth, editDraftedArticle);

module.exports = router;

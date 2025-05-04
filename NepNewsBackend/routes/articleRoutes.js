// routes/articleRoutes.js
const express = require("express");
const router = express.Router();
const auth = require("../middlewares/authMiddleware");
const uploads = require("../config/multer");
const {
  createArticle,
  publishArticle,
  updatePublishedArticle,
  getArticles,
} = require("../controllers/articleController");

// Public route: GET /api/articles
router.get("/", getArticles);

// Protected routes (Author, Editor, Admin)
router.post("/", auth, uploads.single("image"), createArticle);
router.put("/publish/:articleId", auth, publishArticle);
router.put("/admin-update/:articleId", auth, uploads.single("image"),updatePublishedArticle);

module.exports = router;

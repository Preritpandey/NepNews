// controllers/articleController.js
const Article = require("../models/articleModel");
const Log = require("../models/logModel");
const cloudinary = require("../config/cloudinary");
const uploads = require("../config/multer");
const mongoose = require("mongoose");

/**
 * Create draft article (for Author role only)
 */
exports.createArticle = async (req, res) => {
  try {
    // Assume `req.user` is attached by auth middleware with userId, role
    const { title, content, category, keywords} = req.body;
    const authorId = req.user.userId;
    // ------ Image upload handled by Ayusha Karki ----- //
    const result = await cloudinary.uploader.upload(req.file.path);
    // Create draft
    const article = new Article({
      title,
      content,
      category,
      keywords,
      avatar: result.secure_url,
      cloudinary_id: result.public_id,
      author: authorId,
      status: "draft",
    });

    await article.save();
    res.status(201).json({ msg: "Draft article created", article });
  } catch (error) {
    console.error("Error in createArticle:", error);
    res.status(500).json({ msg: "Server error" });
  }
};

/**
 * Editor publishes or updates article
 */
exports.publishArticle = async (req, res) => {
  try {
    const { articleId } = req.params;
    const editorId = req.user.userId;

    console.log("Article ID:", articleId); // Log the article ID
    console.log("Editor ID:", editorId);   // Log the editor ID

    // Find the draft article
    let article = await Article.findById(articleId);
    console.log("Article found:", article); // Log the article object

    if (!article) {
      return res.status(404).json({ msg: "Article not found" });
    }

    // Mark as published
    article.status = "published";
    article.editor = editorId;
    article.publishDate = new Date();

    await article.save();
    console.log("Article published successfully");

    // Log action
    const log = new Log({
      article: article._id,
      action: "publish",
      changedBy: editorId,
    });
    await log.save();
    console.log("Log saved successfully");

    res.json({ msg: "Article published", article });
  } catch (error) {
    console.error("Error in publishArticle:", error);
    res.status(500).json({ msg: "Server error" });
  }
};

/**
 * Only Admin can update an article once published
 */
exports.updatePublishedArticle = async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ msg: "Access denied" });
    }

    const { articleId } = req.params;
    let article = await Article.findById(articleId);
    if (!article) {
      return res.status(404).json({ msg: "Article not found" });
    }

    if (article.status !== "published") {
      return res
        .status(400)
        .json({
          msg: "Article is not published yet, no need for admin override",
        });
    }

    const { title, content, category, keywords } = req.body;

    // Keep track of old data for logs
    const oldData = {
      title: article.title,
      content: article.content,
      category: article.category,
      keywords: article.keywords,
      avatar:article.avatar,
      cloudinary_id:article.cloudinary_id,
    };

    // Update
    if (title !== undefined) article.title = title;
    if (content !== undefined) article.content = content;
    if (category !== undefined) article.category = category;
    if (keywords !== undefined) article.keywords = keywords;
    if (avatar !== undefined) article.avatar = avatar;
    if (cloudinary_id !== undefined) article.cloudinary_id = cloudinary_id;

    await article.save();

    // Log changes
    const changes = {};
    if (req.file) {
        if (article.cloudinary_id) {
          await cloudinary.uploader.destroy(article.cloudinary_id);
        }
  
        const result = await cloudinary.uploader.upload(req.file.path);
        article.avatar = result.secure_url;
        article.cloudinary_id = result.public_id;
  
        changes.avatar = result.secure_url;
      }
  
    if (title && title !== oldData.title) changes.title = title;
    if (content && content !== oldData.content) changes.content = content;
    if (category && category !== oldData.category) changes.category = category;
    if (keywords && keywords !== oldData.keywords) changes.keywords = keywords;

    const log = new Log({
      article: article._id,
      action: "updateAfterPublish",
      changedBy: req.user.userId,
      changes,
    });
    await log.save();

    res.json({ msg: "Article updated by admin", article });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

/**
 * Public: get all published articles with filters (keyword, category, date)
 * No auth required
 */
exports.getArticles = async (req, res) => {
  try {
    const { keyword, category, date } = req.query;
    let query = { status: "published" }; // only published are publicly visible

    if (keyword) {
      // searching in title or content or keywords
      query.$or = [
        { title: { $regex: keyword, $options: "i" } },
        { content: { $regex: keyword, $options: "i" } },
        { keywords: { $regex: keyword, $options: "i" } },
      ];
    }

    if (category) {
      query.category = { $regex: category, $options: "i" };
    }

    if (date) {
      // Assuming date is in YYYY-MM-DD format
      const startOfDay = new Date(date);
      const endOfDay = new Date(date);
      endOfDay.setHours(23, 59, 59, 999);

      query.publishDate = { $gte: startOfDay, $lte: endOfDay };
    }

    const articles = await Article.find(query)
      .populate("author", "name")
      .populate("editor", "name")
      .sort({ publishDate: -1 });

    res.json(articles);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

/**
 * Fetch all drafted articles (for Editor role only)
 */
exports.getDraftedArticles = async (req, res) => {
  try {
    // Ensure the user is an editor
    if (req.user.role !== "editor") {
      return res.status(403).json({ msg: "Access denied" });
    }

    // Fetch all articles with status "draft"
    const drafts = await Article.find({ status: "draft" })
      .populate("author", "name email") // Populate author details
      .sort({ createdAt: -1 }); // Sort by most recent

    res.status(200).json({ drafts });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

/**
 * Edit a drafted article ( for Editor role only)
 */
exports.editDraftedArticle = async (req, res) => {
  try {
    const { articleId } = req.params;
    const { title, content, category, keywords } = req.body;

    // Ensure the user is an editor
    if (req.user.role !== "editor") {
      return res.status(403).json({ msg: "Access denied" });
    }

    // Find the draft article
    const article = await Article.findById(articleId);
    if (!article || article.status !== "draft") {
      return res.status(404).json({ msg: "Draft article not found" });
    }

    // Update the draft article fields
    if (title) article.title = title;
    if (content) article.content = content;
    if (category) article.category = category;
    if (keywords) article.keywords = keywords;

    // Save the updated draft
    await article.save();

    res.status(200).json({ msg: "Draft article updated successfully", article });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

/**
 * Archive a published article (for Admin role only)
 */
exports.archiveArticle = async (req, res) => {
  try {
    const { search } = req.query; // Use req.body instead of req.query

    // Ensure the user is an admin
    if (req.user.role !== "admin") {
      return res.status(403).json({ msg: "Access denied" });
    }

    // Validate the search parameter
    if (!search || typeof search !== "string") {
      return res.status(400).json({ msg: "Invalid search parameter" });
    }

    const query = mongoose.isValidObjectId(search)
      ? { _id: search } // Search by ID if valid ObjectId
      : { title: { $regex: search, $options: "i" } }; // Otherwise, search by title

    // Search for the article
    const article = await Article.findOne({
      ...query,
      status: "published", // Only published articles can be archived
    });

    if (!article) {
      return res.status(404).json({ msg: "Published article not found" });
    }

    // Archive the article by changing its status
    article.status = "archived";
    await article.save();

    res.status(200).json({ msg: "Article archived successfully", article });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

/**
 * Delete a published article (for Admin role only)
 */
exports.deleteArticle = async (req, res) => {
  try {
    const { search } = req.query; // Use req.body instead of req.query

    // Ensure the user is an admin
    if (req.user.role !== "admin") {
      return res.status(403).json({ msg: "Access denied" });
    }

    // Search for the article by ID or title
    const article = await Article.findOne({
      $or: [
        { _id: search }, // Search by ID
        { title: { $regex: search, $options: "i" } }, // Search by title (case-insensitive)
      ],
      status: "archived", // Only published articles can be deleted
    });

    if (!article) {
      return res.status(404).json({ msg: "Published article not found" });
    }

    // Delete the article
    await article.deleteOne();

    res.status(200).json({ msg: "Article deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error" });
  }
};

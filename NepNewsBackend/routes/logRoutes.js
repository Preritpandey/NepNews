const express = require("express");
const router = express.Router();
const auth = require("../middlewares/authMiddleware");
const {
  createLog,
  getAllLogs,
  getLogsByArticle,
  deleteLog,
} = require("../controllers/logController");

// Create a log
router.post("/", auth, createLog);

// Get all logs
router.get("/", auth, getAllLogs);

// Get logs for a specific article
router.get("/article/:articleId", auth, getLogsByArticle);

// Delete a log
router.delete("/:logId", auth, deleteLog);

module.exports = router;
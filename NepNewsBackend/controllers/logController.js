const Log = require("../models/logModel");

// Create a log
exports.createLog = async (req, res) => {
  try {
    const { article, action, changedBy, changes } = req.body;

    const log = await Log.create({
      article,
      action,
      changedBy,
      changes,
    });

    res.status(201).json({ message: "Log created successfully", log });
  } catch (error) {
    console.error("Error creating log:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Get all logs
exports.getAllLogs = async (req, res) => {
  try {
    const logs = await Log.find()
      .populate("article", "title")
      .populate("changedBy", "name");
    res.status(200).json({ logs });
  } catch (error) {
    console.error("Error fetching logs:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Get logs for a specific article
exports.getLogsByArticle = async (req, res) => {
  try {
    const { articleId } = req.params;
    const logs = await Log.find({ article: articleId }).populate(
      "changedBy",
      "name"
    );
    res.status(200).json({ logs });
  } catch (error) {
    console.error("Error fetching logs for article:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Delete a log
exports.deleteLog = async (req, res) => {
  try {
    const { logId } = req.params;
    const log = await Log.findById(logId);

    if (!log) {
      return res.status(404).json({ message: "Log not found" });
    }

    await log.deleteOne();
    res.status(200).json({ message: "Log deleted successfully" });
  } catch (error) {
    console.error("Error deleting log:", error);
    res.status(500).json({ message: "Server error" });
  }
};
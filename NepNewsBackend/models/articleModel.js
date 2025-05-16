// models/articleModel.js
const mongoose = require("mongoose");

const articleSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    content: { type: String, required: true },
    category: {
      type: String,
      enum: ["Technology", "Health", "Education", "Entertainment", "Sports"], // Limit to 5 categories
      required: true, // Ensure a category is selected
    },
    keywords: [{ type: String }], // For easy filtering
    avatar: {
      type: String,
      required: [true, "Ad image URL is required"],
    },
    cloudinary_id: {
      type: String,
      required: [true, "Ad image URL is required"],
    },
    publishDate: { type: Date },
    status: {
      type: String,
      enum: ["draft", "published","archived"],
      default: "draft",
    },
    author: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    editor: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Article", articleSchema);

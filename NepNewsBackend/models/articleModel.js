// models/articleModel.js
const mongoose = require("mongoose");

const articleSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    content: { type: String, required: true },
    category: { type: String, required: true },

    keywords: [{ type: String }], // For easy filtering
    avatar: {
      type: String,
      required: [true, "Ad image URL is required"],
    },
    cloudinary_id: {
      type: String,
      required: [true, "Ad image URL is required"],
    },
    keywords: [{ type: String }], // For easy filtering
    publishDate: { type: Date },
    status: {
      type: String,
      enum: ["draft", "published"],
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

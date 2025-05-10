// models/userModel.js
const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String, // Hashed password
    required: true,
  },
  googleId: { type: String, unique: true, sparse: true },
  role: {
    type: String,
    enum: ["admin", "author", "editor", "adsManager"],
    default: "author",
  },
});

module.exports = mongoose.model("User", userSchema);

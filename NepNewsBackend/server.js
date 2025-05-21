// server.js
require("dotenv").config();
const express = require("express");
const connectDB = require("./config/db");
const authMiddleware = require("./middlewares/authMiddleware");
const session = require("express-session");
const passport = require("passport");
require("./config/passport")(passport);

// Import routes
const authRoutes = require("./routes/authRoutes");
const articleRoutes = require("./routes/articleRoutes");
const adRoutes = require("./routes/adRoutes");
const userRoutes = require("./routes/userRoutes");
const horoscopeRoutes = require("./routes/horoscopeRoutes");

const app = express();

app.use(
  session({
    secret: "your-secret",
    resave: false,
    saveUninitialized: false,
  })
);

app.use(passport.initialize());
app.use(passport.session());

app.use("/auth", require("./routes/authRoutes"));

app.use(express.json());
// Database connection
connectDB();
app.use("/ad", adRoutes);
// Routes
app.use("/api/auth", authRoutes);
app.use("/api/articles", articleRoutes);
app.use("/api/users", userRoutes);
app.use("/api/horoscope", horoscopeRoutes);

// Middleware

app.get("/", (req, res) => {
  res.send("Welcome to NepNews backend API");
});

// Start server
const PORT = process.env.PORT || 8083;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

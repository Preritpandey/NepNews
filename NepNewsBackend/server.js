// server.js
require("dotenv").config();
const express = require("express");
const connectDB = require("./config/db");
const session   = require("express-session");
const passport  = require("passport");
const cors      = require("cors");

require("./config/passport")(passport);

const app = express();

/* ---------- GLOBAL MIDDLEWARE (runs before any routes) ---------- */
app.use(cors());
app.use(express.json());                       // <-- must come BEFORE routes
app.use(express.urlencoded({ extended: true })); // if you ever accept form data

app.use(session({
  secret: "your-secret",
  resave: false,
  saveUninitialized: false,
}));

app.use(passport.initialize());
app.use(passport.session());

/* ---------- ROUTES ---------- */
app.use("/auth", require("./routes/authRoutes")); // consider keeping only one of these
app.use("/api/auth", require("./routes/authRoutes"));

app.use("/api/articles", require("./routes/articleRoutes"));
app.use("/api/comments", require("./routes/commentRoutes")); // now sees parsed body
app.use("/api/ad",       require("./routes/adRoutes"));
app.use("/api/users",    require("./routes/userRoutes"));

/* ---------- MISC ---------- */
app.get("/", (_req, res) => {
  res.send("Welcome to NepNews backend API");
});

connectDB();
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

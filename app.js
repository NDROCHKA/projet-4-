import "dotenv/config";
import express from "express";
import bodyParser from "body-parser";
import connect from "./config/database.js";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";

import authRouter from "./authentication/auth.route.js";
import userRoute from "./user/user.route.js";
import pageRoute from "./page/page.route.js";
import postRouter from "./post/post.route.js";
import videoRouter from "./videos/video.route.js";

const { json, urlencoded } = bodyParser;
const app = express();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Connect to database first
connect();

// Apply CORS FIRST - before any routes
app.use(cors());

// Then body parser middleware
app.use(urlencoded({ extended: false }));
app.use(json());

app.use(express.static(path.join(__dirname, "web")));

// Then your routes
app.use("/auth", authRouter);
app.use("/user", userRoute);
app.use("/page", pageRoute);
app.use("/post", postRouter);
app.use("/video", videoRouter);

// FIXED THIS LINE - removed the extra =>
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "web", "index.html"));
});

app.listen(3500, "0.0.0.0", () => {
  console.log("Server is running on port 3500");
});

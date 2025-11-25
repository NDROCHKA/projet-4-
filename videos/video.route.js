import express from "express";
import {
  uploadVideo,
  getVideos,
  getPopularVideos,
  getRecentVideos,
  incrementView,
  getVideo,
  deleteVideo,
} from "./video.controller.js";
import upload from "../config/multer.js";
import Authenticate from "../authentication/middelware_authentication.js";

const router = express.Router();

// POST /api/videos - Upload video
router.post(
  "/uploadvideo",
  Authenticate.authenticateJwt,
  upload.fields([
    { name: "video", maxCount: 1 },
    { name: "thumbnail", maxCount: 1 },
  ]),
  uploadVideo
);

// GET /api/videos - Get all videos
router.get("/getvideos", Authenticate.authenticateJwt, getVideos);

// GET /api/videos/:id - Get single video
router.get("/getvideo/:id", Authenticate.authenticateJwt, getVideo);

// GET /api/videos/popular - Get popular videos
router.get("/popular", Authenticate.authenticateJwt, getPopularVideos);

// GET /api/videos/recent - Get recent videos
router.get("/recent", Authenticate.authenticateJwt, getRecentVideos);

// POST /api/videos/:id/view - Increment view count
router.post("/:id/view", Authenticate.authenticateJwt, incrementView);

// DELETE /api/videos/:id - Delete video
router.delete("/deletevideo/:id", Authenticate.authenticateJwt, deleteVideo);

export default router;

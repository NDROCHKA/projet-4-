import express from "express";
import {
  uploadVideo,
  getVideos,
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

// GET /api/videos - Get all videos (PUBLIC - no auth required)
router.get("/getvideos", getVideos);

// GET /api/videos/:id - Get single video (PUBLIC - no auth required)
router.get("/getvideo/:id", getVideo);

// DELETE /api/videos/:id - Delete video (PROTECTED - auth required)
router.delete("/deletevideo/:id", Authenticate.authenticateJwt, deleteVideo);

export default router;

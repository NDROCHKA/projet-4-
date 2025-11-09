import { Router } from "express";
import {
  uploadVideo,
  getVideos,
  getVideo,
  deleteVideo,
} from "./video.controller.js";
import upload from "../config/multer.js";
const router = exoress.Router();
router.post("/");

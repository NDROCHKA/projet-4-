// post/post.route.js
import express from "express";
import postController from "./post.controller.js";
import Authenticate from "../authentication/middelware_authentication.js";

const router = express.Router();

// Protected routes (user-specific)
router.post(
  "/createPost",
  Authenticate.authenticateJwt,
  postController.createPost
);
router.get("/myPosts", Authenticate.authenticateJwt, postController.getMyPosts);
router.delete(
  "/deleteMyPost",
  Authenticate.authenticateJwt,
  postController.deleteMyPost
);

// Public routes (anyone can access)
router.get("/findOne/:postId", postController.findOne);
router.get("/findAll", postController.findAll);

export default router;

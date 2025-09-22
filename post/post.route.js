import express from "express";
import postController from "./post.controller.js";
import Authenticate from "../authentication/middelware_authentication.js";

const router = express.Router();

router.post(
  "/createPost",
  Authenticate.authenticateJwt,
  postController.createPost
);
router.get("/findOne", postController.findOne);
router.get("/findAll", postController.findAll);
router.delete(
  "/deleteOne",
  Authenticate.authenticateJwt,
  postController.deleteOne
);
export default router;

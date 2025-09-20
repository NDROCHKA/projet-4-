import express from "express"
import postController from"./post.controller.js"

const router = express();

router.get("/createPost" , postController.createPost);
router.get("/findOne", postController.findOne);
router.get("/findAll" , postController.findAll);
router.delete("/deleteOne", postController.deleteOne);
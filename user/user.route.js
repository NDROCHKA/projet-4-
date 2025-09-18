import express from "express"
import userController from "./user.controller.js"

const router = express.Router();

router.get("/findOne", userController.findOne);
router.get("/findAll", userController.findAll);
router.delete("/deleteOne", userController.deleteUser);


export default router;

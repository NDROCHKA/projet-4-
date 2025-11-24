import express from "express";
import pageController from "./page.controller.js";
import Authenticate from "../authentication/middelware_authentication.js";
const router = express.Router();

router.post("/createpage", pageController.createPage);
router.get("/mypage", Authenticate.authenticateJwt, pageController.getMyPage);
// router.get("/findOne", pageController.findPage);
// router.get("/findAll", pageController.findAll);
// router.delete("/delete", pageController.deleteOne);
export default router;
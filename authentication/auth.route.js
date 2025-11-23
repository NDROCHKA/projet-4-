import express from "express";
import authController from "./auth.controller.js";
import Authenticate from "./middelware_authentication.js";

const router = express.Router();

router.post("/register", authController.register);
router.post("/login", authController.login);
router.post(
  "/verifyUser",
  Authenticate.authenticateJwt,
  authController.verifyUser
);

export default router;

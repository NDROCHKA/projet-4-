import express from "express";
import authController from "./auth.controller.js";
import Authenticate from "./middelware_authentication.js"

const authRouter = express.Router();

authRouter.post("/register",authController.register)
authRouter.get("/login", authController.login)
authRouter.get(
  "/verifyUser",
  Authenticate.authenticateJwt,
  authController.verifyUser
);


export default authRouter;
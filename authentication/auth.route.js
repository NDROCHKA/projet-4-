import express from "express";
import authController from "./auth.controller.js";

const authRouter = express.Router();

authRouter.post("/register",authController.register)
authRouter.get("/login", authController.login)

export default authRouter;
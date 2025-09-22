import express from "express"
import userController from "./user.controller.js"
import Authenticate from "../authentication/middelware_authentication.js"

const router = express.Router();

router.get("/findAll", userController.findAll);
router.delete("/deleteOne", Authenticate.authenticateJwt , userController.deleteUser);

export default router;

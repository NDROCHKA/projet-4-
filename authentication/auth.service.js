import userSchema from "./auth.model.js";
import pageService from "../page/page.service.js";
import verifyTokenFromHeader from "./middelware_authentication.js";
import { signToken } from "../utils/jwt.utils.js";

import bcrypt from "bcrypt";
class authService {
  static async register(firstName, lastName, email, password) {
    const saltRounds = 12;
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    const user = await new userSchema({
      firstName,
      lastName,
      email,
      password: hashedPassword,
    }).save();
    pageService.createPage(email);
    return user;
  }

  static async login(email, password) {
    const user = await userSchema.findOne({ email });

    if (!user) {
      throw new Error(" user not found");
    }
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      throw new Error("Email or password is incorrect");
    }
    const token = signToken({ _id: user._id, email: user.email });
    return token;
  }
  static async verifyUser(userIdFromToken, email) {
    const user = await userSchema.findOne({ email });
    if (!user) {
      throw new Error("User not found");
    }
    if (userIdFromToken !== user._id.toString()) {
      throw new Error("Token does not belong to this user");
    }

    return user;
  }
}
export default authService;

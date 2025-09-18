import userSchema from "./auth.model.js";
import pkg from "jsonwebtoken";
const { sign } = pkg;
class authService {
  static async register(firstName, lastName, email, password) {
    const user = await new userSchema({
      firstName,
      lastName,
      email,
      password,
    }).save();
    return user;
  }

  static async login(email, password) {
    const user = await userSchema.findOne({ email });

    if (!user) {
      throw new Error(" user not found");
    }
    if (password != user.password) {
      throw Error("email or password is incorrect,  ");
    }
    const token = await this.signJwt({ _id: user._id });
  }
  static async signJwt(userPayload) {
    return sign(userPayload, "expressOP", { expiresIn: "1y" });
  }
}
export default authService;

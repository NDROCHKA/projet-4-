import userSchema from "../authentication/auth.model.js";
import pkg from "jsonwebtoken";
const { verify } = pkg;
class userService {

  static async findAll() {
    return userSchema.find();
  }
  static async deleteUser(_id, authHeader) {
    const token = this.verifyToken(authHeader);
    if (!token) {
      return null;
    }
    const user = await userSchema.deleteOne({ _id });
    return user;
  }
}
export default userService;

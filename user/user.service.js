import userSchema from "../authentication/auth.model.js";
import pkg from "jsonwebtoken";
const { verify } = pkg;
class userService {
  static async findOne(email, authHeader) {
    const user = await userSchema.findOne({ email });
    if (!user) {

      throw new Error(" user not found");
    }
    const payload = await this.verifyToken(authHeader);
    console.log(payload);

    return payload;
  }
  static async verifyToken(authHeader) {
    const token = authHeader.split(" ")[1];
    const payload = verify(token, "expressOP");

    if (!payload) {
      return undefined;
    }
    return payload;
  }
  static async findAll(){
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

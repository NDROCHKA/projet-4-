import userSchema from "../authentication/auth.model.js";
import pageSchema from "../page/page.model.js";

class userService {
  static async findAll() {
    return userSchema.find();
  }
  static async deleteUser(_id) {
    await pageSchema.deleteOne({ userId: _id });
    const user = await userSchema.deleteOne({ _id });
    return user;
  }
}
export default userService;

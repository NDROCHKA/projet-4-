import userSchema from "../authentication/auth.model.js";
class userService {
  static async findAll() {
    return userSchema.find();
  }
  static async deleteUser(_id) {
    const user = await userSchema.deleteOne({ _id });
    return user;
  }
}
export default userService;

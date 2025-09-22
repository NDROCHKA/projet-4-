import userService from "./user.service.js";

class userController {

  static async findAll(req, res) {
    try {
      const users = await userService.findAll();
      res.status(200).json({ message: " here all the user's", users });
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
  static async deleteUser(req, res) {
    try {
      const { _id } = req.body;
      const user = await userService.deleteUser(_id, );
      res.status(200).json(user);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
}
export default userController;

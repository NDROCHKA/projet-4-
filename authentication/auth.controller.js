import authService from "./auth.service.js";
class authController {
  static async register(req, res) {
    try {
      const { firstname, lastname, email, password } = req.body;
      let auth = await authService.register(
        firstname,
        lastname,
        email,
        password
      );
      if (email === undefined || password === undefined) {
        throw new error("email and password required");
      }
      res.status(200).json({ auth, message: " user creation succsessfull" });
    } catch (error) {
      res
        .status(400)
        .json({ message: "the user:", auth, message: "cannot be created" });
    }
  }

  static async login(req, res) {
    //checks if its defined
    //if yes res.status(200)
    //if no res.status(400)
  }
}
export default authController;

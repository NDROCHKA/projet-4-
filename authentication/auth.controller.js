import authService from "./auth.service.js";
class authController {
  static async register(req, res) {
    try {
      const { firstname, lastname, email, password } = req.body;

      if (!email || !password) {
        return res
          .status(400)
          .json({ message: "Email and password are required" });
      }

      let user = await authService.register(
        firstname,
        lastname,
        email,
        password
      );
      res.status(201).json({
        message: "User created successfully",
        data: user,
      });
    } catch (error) {
      res.status(400).json({
        message: "User could not be created",
        error: error.message,
      });
    }
  }

  static async login(req, res) {
    try {
      const { email, password } = req.body;
      if (password != undefined && email != undefined) {
        let auth = await authService.login(email, password);
        res.status(200).json({ auth, message: " User found" });
      } else {
        throw new Error(" missing email or password");
      }
    } catch (error) {
      console.error("Error during login", error);
      res.status(400).json({ message: " user not found in the database" });
    }
  }
}

export default authController;

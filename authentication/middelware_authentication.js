// middleware/authenticate.js
import pkg from "jsonwebtoken";
const { verify } = pkg 
class Authenticate {
  static async authenticateJwt(req, res, next) {
    try {
      const authHeader = req.headers.authorization;
      if (!authHeader || !authHeader.startsWith("Bearer")) {
        return res
          .status(401)
          .json({ message: "Invalid authorization header" });
      }
const token = authHeader.split(" ")[1];
      const payload = verify(token , "expressOP");
      req.user = payload;
      next();
    } catch (error) {
      next(error)
    }
  }
}
export default Authenticate;

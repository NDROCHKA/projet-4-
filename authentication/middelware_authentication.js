// middleware/authenticate.js
import { verifyTokenFromHeader } from "../utils/utils.verifyToken.js";
class Authenticate {
  static async authenticateJwt(req, res, next) {
    try {
      const authHeader = req.headers.authorization;
      const payload = verifyTokenFromHeader(authHeader);
      req.user = payload;
      next();
    } catch (error) {
      return res.status(444).json({ message: "unrecognized token" });
    }
  }
}
export default Authenticate;

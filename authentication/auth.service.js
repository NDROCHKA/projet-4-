import AuthModel from "./auth.model.js";
class authService {
  static async register(firstName, lastName, email, password) {
    await new AuthModel({ firstName, lastName, email, password }).save();
  }
  static async login(firstNamename, lastName, email, password) {
    //here logic to login and check for everything before giving access to the account
  }
}
export default authService;

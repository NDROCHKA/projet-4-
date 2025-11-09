// page/page.service.js
import pageModel from "./page.model.js";

class pageService {
  static async createPage(userId, email) {
    // FIX: Create page with both userId and email
    const page = await new pageModel({
      userId: userId,
      email: email,
    }).save();
    return page;
  }
}
export default pageService;

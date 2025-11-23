// page/page.service.js
import pageModel from "./page.model.js";

class pageService {
  static async createPage(email, userId) {
    const page = await new pageModel({ email, userId }).save();
    return page;
  }
}
export default pageService;

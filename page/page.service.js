// page/page.service.js
import pageModel from "./page.model.js";

class pageService {
  static async createPage(email, userId, name = '', profileImage = '', description = '') {
    const page = await new pageModel({
      email,
      userId,
      name,
      profileImage,
      description
    }).save();
    return page;
  }

  static async getPageByUserId(userId) {
    const page = await pageModel.findOne({ userId: userId });
    return page;
  }
}
export default pageService;

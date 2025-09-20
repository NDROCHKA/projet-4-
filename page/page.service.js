import pageModel from "./page.model.js";

class pageService {
  static async createPage(email) {

    const page = await new pageModel({ email }).save();
    return page;
  }
}
export default pageService;

import pageService from "./page.service.js";

class pageController {
  static async createPage(req, res) {
    try {
      const { email } = req.body;
      await pageService.createPage(email);
      res.status(res, {
        statuscode: 201,
        message: "page created",
      });
    } catch (Error) {
      res.status(400).json({ message: "error creating page" });
    }

  }
}
export default pageController;

// page/page.controller.js
import pageService from "./page.service.js";

class pageController {
  static async createPage(req, res) {
    try {
      const { userId, email } = req.body; // Get both from body
      await pageService.createPage(userId, email);
      res.status(201).json({
        statusCode: 201,
        message: "page created",
      });
    } catch (Error) {
      res.status(400).json({ message: "error creating page" });
    }
  }
}
export default pageController;

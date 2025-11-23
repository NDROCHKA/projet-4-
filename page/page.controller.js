// page/page.controller.js
import pageService from "./page.service.js";

class pageController {
  static async createPage(req, res) {
    try {
      const { email, userId } = req.body;
      if (!email || !userId) {
        return res.status(400).json({ message: "email and userId are required" });
      }
      await pageService.createPage(email, userId);
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

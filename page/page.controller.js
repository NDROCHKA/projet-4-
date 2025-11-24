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

  static async getMyPage(req, res) {
    try {
      const userId = req.user._id;
      const page = await pageService.getPageByUserId(userId);
      
      if (!page) {
        return res.status(404).json({ message: "Page not found" });
      }

      res.status(200).json({
        statusCode: 200,
        message: "Page found",
        data: page
      });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}
export default pageController;

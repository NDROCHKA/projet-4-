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
    //the logic that i want is that for each user only 1 page will be created
    // automaticaly after the user registers so no verification is needed,
    //and when the user want to post on that page, the verify_user function will be called to make sure its not a haker
    //and after its created i will add it to the array of posts in the model of the page
  }
}
export default pageController;

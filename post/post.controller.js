import postService from "./post.service.js";

class postController {
  static async createPost(req, res) {
    try {
      const userId = req.user._id;
      const userEmail = req.user.email;
      const { title, content } = req.body;
      let post = await postService.createPost(
        userId,
        userEmail,
        title,
        content
      );
      res.status(200).json({ messgage: "post successful\n,", post });
    } catch (Error) {
      res.status(401).json({ messgage: "post unsuccessful\n,", Error });
    }
  }
  static async findOne(req, res) {}
  static async findAll(req, res) {}
  static async deleteOne(req, res) {}
}
export default postController;

// post/post.controller.js
import postService from "./post.service.js";

class postController {
  static async createPost(req, res) {
    try {
      const userId = req.user._id; // From JWT token
      const { title, content } = req.body;

      let post = await postService.createPost(userId, title, content);
      res.status(200).json({ message: "Post successful", post });
    } catch (Error) {
      res
        .status(401)
        .json({ message: "Post unsuccessful", error: Error.message });
    }
  }

  static async getMyPosts(req, res) {
    try {
      const userId = req.user._id;
      const posts = await postService.getMyPosts(userId);
      res.status(200).json({ posts });
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }

  static async deleteMyPost(req, res) {
    try {
      const userId = req.user._id;
      const { postId } = req.body;

      await postService.deleteMyPost(postId, userId);
      res.status(200).json({ message: "Post deleted successfully" });
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }

  // Public endpoints (no auth needed)
  static async findOne(req, res) {
    try {
      const { postId } = req.params;
      const post = await postService.getPostById(postId);
      if (!post) {
        return res.status(404).json({ message: "Post not found" });
      }
      res.status(200).json({ post });
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }

  static async findAll(req, res) {
    try {
      const posts = await postService.getAllPosts();
      res.status(200).json({ posts });
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
}
export default postController;
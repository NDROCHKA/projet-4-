// post/post.service.js
import Post from "./post.model.js";
import Page from "../page/page.model.js";

class postService {
  static async createPost(userId, title, content) {
    // Find user's page automatically by userId
    const userPage = await Page.findOne({ userId: userId });
    if (!userPage) {
      throw new Error("Page not found for this user");
    }

    // Create post on user's page automatically
    const newPost = new Post({
      title: title,
      content: content,
      pageId: userPage._id, // Auto-set the pageId
    });

    return await newPost.save();
  }

  static async getMyPosts(userId) {
    // Find user's page and get their posts
    const userPage = await Page.findOne({ userId: userId });
    if (!userPage) return [];

    return await Post.find({ pageId: userPage._id });
  }

  static async deleteMyPost(postId, userId) {
    // Find user's page and verify post belongs to them
    const userPage = await Page.findOne({ userId: userId });
    if (!userPage) throw new Error("Page not found");

    const post = await Post.findOne({ _id: postId, pageId: userPage._id });
    if (!post) throw new Error("Post not found or access denied");

    return await Post.findByIdAndDelete(postId);
  }

  // Keep these for public access (no auth needed)
  static async getAllPosts() {
    return await Post.find().populate("pageId");
  }

  static async getPostById(postId) {
    return await Post.findById(postId).populate("pageId");
  }
}
export default postService;
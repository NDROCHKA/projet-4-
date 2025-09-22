import post from "./post.model.js";
import page from "../page/page.model.js";

class postService {
  static async createPost(userId, userEmail, title, content) {
    const userPage = await page.findOne({ email: userEmail });
    if (!userPage) {
      throw new error("page not found, make sure page is created fisrt");
    }
   const newPost = new post({
     title: title,
     content: content,
     authorEmail: userEmail,
     authorId: userId, // Mongoose will auto-convert string to ObjectId
   });

    const savedNewPost = await newPost.save();
    userPage.posts.push(savedNewPost._id);
    await userPage.save();

    return savedNewPost;
  }
}
export default postService;

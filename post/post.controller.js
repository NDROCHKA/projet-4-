import postService from"./post.service.js"

class postController {
  static async createPost(req, res) {
    try{
        const{title , content , token } = req.body;
        // here i call the middleman that i need to create that has authenticate, it has the verify function
        let post = postService.createPost(title , content)
    }
    catch(Error){}
  }
  static async findOne(req, res) {}
  static async findAll(req, res) {}
  static async deleteOne(req, res) {}
}
export default postController;
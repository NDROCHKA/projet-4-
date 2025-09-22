import mongoose from "mongoose";
const { Schema } = mongoose;

const postSchema = new Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  authorEmail:{type:String , required:true},
  authorId: {
    type: Schema.Types.ObjectId, // stores the Users ID when i pass it in the serviec
    ref: "user", // reference to the user model
    required: true,
  },
  createdAt: { type: Date, default: Date.now },
});

const Post = mongoose.model("Post", postSchema);

export default Post;
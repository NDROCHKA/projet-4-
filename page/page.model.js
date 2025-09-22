import mongoose from "mongoose";
import postSchema from "../post/post.model.js"; // Import the SCHEMA

const { Schema } = mongoose;

const pageSchema = new Schema({
  posts: [
    {
      type: Schema.Types.ObjectId, // Store only the Post ID
      ref: "Post", // Reference to the Post model
    },
  ],
  email: { type: String, required: true },
  default: [],
});

export default mongoose.model("page", pageSchema);

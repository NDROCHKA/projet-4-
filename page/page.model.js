import mongoose from "mongoose";
import postSchema from "../post/post.model.js"; // Import the SCHEMA

const { Schema } = mongoose;

const pageSchema = new Schema({
  posts: {
    type: [postSchema], // Array of post sub-documents
    required: false,
    default: [],
  },
  email: { type: String, required: true },
  default: [],
});

export default mongoose.model("page", pageSchema);

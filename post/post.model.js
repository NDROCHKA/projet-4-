// post/post.model.js
import mongoose from "mongoose";
const { Schema } = mongoose;

const postSchema = new Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  pageId: {
    type: Schema.Types.ObjectId,
    ref: "page",
    required: true,
  },
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model("Post", postSchema);

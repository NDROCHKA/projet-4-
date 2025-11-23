import mongoose from "mongoose";
const { Schema } = mongoose;

const videoSchema = new Schema({
  title: { type: String, required: true, maxLength: [100] },
  pageId: {
    type: Schema.Types.ObjectId,
    ref: "page",
    required: true,
  },
  videoUrl: { type: String, required: true },
  thumbnailUrl: { type: String, required: false },
  description: { type: String, required: false },
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model("video", videoSchema);

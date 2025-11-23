// page/page.model.js
import mongoose from "mongoose";
const { Schema } = mongoose;

const pageSchema = new Schema({
  name: { type: String, required: false },
  email: { type: String, required: true, unique: true },
  profileImage: { type: String, required: false },
  description: { type: String, required: false },
  userId: {
    type: Schema.Types.ObjectId,
    ref: "user",
    required: true,
  },
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model("page", pageSchema);

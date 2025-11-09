// page/page.model.js
import mongoose from "mongoose";
const { Schema } = mongoose;

const pageSchema = new Schema({
  email: { type: String, required: true, unique: true },
  userId: {
    type: Schema.Types.ObjectId,
    ref: "user",
    required: true,
  },
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model("page", pageSchema);

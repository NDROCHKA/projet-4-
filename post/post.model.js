import mongoose from "mongoose";
const { Schema } = mongoose;

const postSchema = new Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  authorEmail:{type:String , required:true},
  authorId: {
    type: Schema.Types.ObjectId, // Stores the User's ID
    ref: "user", // Reference to the ser model
    required: true,
  },
  createdAt: { type: Date, default: Date.now },
});

const Post = mongoose.model("Post", postSchema);

// Export the Model, not the Schema
export default Post; // Export the schema, not the model , why , whats the diffrence

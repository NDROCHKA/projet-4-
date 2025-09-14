import mongoose from "mongoose";
const DB_HOST = "127.0.0.1";
const DB_PORT = 27017;
const DB_NAME = "miniSocialMediaBackEnd";
const connectionString = `mongodb://${DB_HOST}:${DB_PORT}/${DB_NAME}`;
export const connect = () => {
  mongoose
    .connect(connectionString, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })
    .then(() => {
      console.log("Data base connected succesfully ");
    })
    .catch((err) => console.error("MongoDB connection error", err));
};
export default connect;

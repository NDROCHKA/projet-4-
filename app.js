import express from "express";
import bodyParser from "body-parser";
import connect from "./config/database.js";

import authRouter from "./authentication/auth.route.js";

import userRoute from "./user/user.route.js";

const { json, urlencoded } = bodyParser;
const app = express();
app.use(urlencoded({ extended: false }));
connect();
app.use(json());

app.use("/auth", authRouter);
app.use("/user", userRoute);

app.get("/", (req, res) => {
  res.status(200).send("Server is running successfully!");
});
app.listen(3500, () => {
  console.log("listing to port 3500");
});

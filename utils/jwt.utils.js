// utils/jwt.utils.js
import pkg from "jsonwebtoken";
const { sign } = pkg;

export const signToken = (payload) => {
  return sign(payload, "expressOP", { expiresIn: "1y" });
};

// You can also keep other JWT-related functions here later

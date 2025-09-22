import pkg from "jsonwebtoken";
const { sign } = pkg;

export const signToken = (payload) => {
  return sign(payload, "expressOP", { expiresIn: "1y" });
};

//keep other jwt related functions here later

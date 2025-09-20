import pkg from "jsonwebtoken";
const { verify, sign } = pkg;

// Function to verify a token from an auth header
export const verifyTokenFromHeader = (authHeader) => {
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    throw new Error("Invalid authorization header format");
  }

  const token = authHeader.split(" ")[1];
  try {
    // Use your secret key (preferably from process.env.JWT_SECRET)
    const payload = verify(token, "expressOP");
    return payload;
  } catch (error) {
    throw new Error("Invalid or expired token");
  }
};

// You can also move the sign function here for consistency
export const signToken = (payload) => {
  return sign(payload, "expressOP", { expiresIn: "1y" });
};

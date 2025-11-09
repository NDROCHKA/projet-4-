import AWS from "aws-sdk";

// Configure Backblaze B2
const s3 = new AWS.S3({
  endpoint: process.env.B2_ENDPOINT,
  accessKeyId: process.env.B2_KEY_ID,
  secretAccessKey: process.env.B2_APPLICATION_KEY,
  region: process.env.B2_REGION || "us-west-002",
});

/**
 * Upload file to Backblaze B2
 * @param {Object} file - Multer file object
 * @param {String} folder - videos or thumbnails
 * @returns {Object} { url, key }
 */
export const uploadToBackblaze = async (file, folder = "videos") => {
  try {
    const fileExtension = file.originalname.split(".").pop();
    const fileName = `${folder}/${Date.now()}-${Math.random()
      .toString(36)
      .substring(7)}.${fileExtension}`;

    const params = {
      Bucket: process.env.B2_BUCKET_NAME,
      Key: fileName,
      Body: file.buffer,
      ContentType: file.mimetype,
      ACL: "public-read",
    };

    const result = await s3.upload(params).promise();

    return {
      url: result.Location, // Backblaze URL
      key: result.Key,
    };
  } catch (error) {
    throw new Error(`Backblaze upload failed: ${error.message}`);
  }
};

/**
 * Delete file from Backblaze B2
 * @param {String} fileKey - File key to delete
 */
export const deleteFromBackblaze = async (fileKey) => {
  try {
    const params = {
      Bucket: process.env.B2_BUCKET_NAME,
      Key: fileKey,
    };
    await s3.deleteObject(params).promise();
  } catch (error) {
    throw new Error(`Backblaze delete failed: ${error.message}`);
  }
};

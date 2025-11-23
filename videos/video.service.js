import B2 from "backblaze-b2";

// Load credentials from environment variables
const b2 = new B2({
  applicationKeyId: process.env.B2_APPLICATION_KEY_ID,
  applicationKey: process.env.B2_APPLICATION_KEY,
});

export const uploadToBackblaze = async (file, folder) => {
  try {
    console.log("Starting Backblaze upload...");

    // Authorize first
    await b2.authorize();
    console.log("Authorization successful");

    // Use bucket ID from environment variable
    const bucketId = process.env.B2_BUCKET_ID;

    // Get upload URL
    const uploadUrlResponse = await b2.getUploadUrl({
      bucketId: bucketId,
    });
    console.log("Got upload URL");

    // Generate filename
    const fileName = `${folder}/${Date.now()}-${file.originalname.replace(
      /\s/g,
      "_"
    )}`;
    console.log("Uploading file:", fileName);

    // Upload file
    const uploadResponse = await b2.uploadFile({
      uploadUrl: uploadUrlResponse.data.uploadUrl,
      uploadAuthToken: uploadUrlResponse.data.authorizationToken,
      fileName: fileName,
      data: file.buffer,
      contentLength: file.size,
      mime: file.mimetype,
    });
    console.log("Upload successful");

    // Construct URL using environment variable
    const fileUrl = `${process.env.B2_BUCKET_URL}/${fileName}`;

    return {
      url: fileUrl,
      fileName: fileName,
    };
  } catch (error) {
    console.error("Backblaze upload error:", error.message);
    throw new Error(`Backblaze upload failed: ${error.message}`);
  }
};

export const deleteFromBackblaze = async (fileName) => {
  try {
    await b2.authorize();
    const bucketId = process.env.B2_BUCKET_ID;

    const listFilesResponse = await b2.listFileNames({
      bucketId: bucketId,
      startFileName: fileName,
      maxFileCount: 1,
    });

    const file = listFilesResponse.data.files.find(
      (f) => f.fileName === fileName
    );

    if (!file) {
      console.log("File not found:", fileName);
      return;
    }

    await b2.deleteFileVersion({
      fileId: file.fileId,
      fileName: fileName,
    });
  } catch (error) {
    throw new Error(`Backblaze delete failed: ${error.message}`);
  }
};

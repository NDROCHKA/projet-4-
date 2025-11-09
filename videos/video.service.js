import B2 from "backblaze-b2";

// Use these EXACT credentials from your screenshot
const b2 = new B2({
  applicationKeyId: "60a7fbb31d6a", // Your Master Key ID
  applicationKey: "005bdd962903396e499b7a85b4b944528ba326c2b1", // Your NEW Application Key
});

export const uploadToBackblaze = async (file, folder) => {
  try {
    console.log("Starting Backblaze upload...");

    // Authorize first
    await b2.authorize();
    console.log("Authorization successful");

    // Use your exact bucket ID
    const bucketId = "96b08ae7df0b6b9391ad061a";

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

    // Construct URL
    const fileUrl = `https://miniYoutubeMedia.s3.us-east-005.backblazeb2.com/${fileName}`;

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
    const bucketId = "96b08ae7df0b6b9391ad061a";

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

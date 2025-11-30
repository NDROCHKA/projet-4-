import Video from "./video.model.js";
import { uploadToBackblaze, deleteFromBackblaze } from "./video.service.js";

// Upload video
export const uploadVideo = async (req, res) => {
  try {
    // Validate required fields
    if (!req.body.title || !req.body.pageId) {
      return res.status(400).json({
        success: false,
        message: "Title and pageId are required",
      });
    }

    if (!req.files || !req.files.video) {
      return res.status(400).json({
        success: false,
        message: "Video file is required",
      });
    }

    const videoFile = req.files.video[0];
    const thumbnailFile = req.files.thumbnail ? req.files.thumbnail[0] : null;

    // 1. Upload video to Backblaze B2
    const videoResult = await uploadToBackblaze(videoFile, "videos");

    // 2. Upload thumbnail to Backblaze B2 (if provided)
    let thumbnailUrl = "";
    if (thumbnailFile) {
      const thumbnailResult = await uploadToBackblaze(
        thumbnailFile,
        "thumbnails"
      );
      thumbnailUrl = thumbnailResult.url;
    }

    // 3. Save ONLY URLs to MongoDB
    const video = new Video({
      title: req.body.title,
      pageId: req.body.pageId,
      videoUrl: videoResult.url, // Backblaze URL
      thumbnailUrl: thumbnailUrl, // Backblaze URL
      description: req.body.description || "",
    });

    await video.save();

    res.status(201).json({
      success: true,
      message: "Video uploaded successfully",
      data: video,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get all videos
export const getVideos = async (req, res) => {
  try {
    console.log('GET /video/getvideos - Fetching all videos...');

    const videos = await Video.find()
      .populate({
        path: "pageId",
        select: "name",
        options: { strictPopulate: false }
      })
      .sort({ createdAt: -1 })
      .lean();

    console.log(`Found ${videos.length} videos`);

    if (videos.length > 0) {
      console.log('First video:', JSON.stringify(videos[0], null, 2));
    }

    res.json({
      success: true,
      count: videos.length,
      data: videos,
    });
  } catch (error) {
    console.error('Error fetching videos:', error);
    res.status(500).json({
      success: false,
      message: "Error fetching videos",
      error: error.message,
    });
  }
};

// Get popular videos (sorted by views desc)
export const getPopularVideos = async (req, res) => {
  try {
    const videos = await Video.find()
      .populate("pageId", "name")
      .sort({ views: -1 });

    res.json({
      success: true,
      count: videos.length,
      data: videos,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error fetching popular videos",
    });
  }
};

// Get recent videos (sorted by createdAt desc)
export const getRecentVideos = async (req, res) => {
  try {
    const videos = await Video.find()
      .populate("pageId", "name")
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: videos.length,
      data: videos,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error fetching recent videos",
    });
  }
};

// Increment view count
export const incrementView = async (req, res) => {
  try {
    const video = await Video.findByIdAndUpdate(
      req.params.id,
      { $inc: { views: 1 } },
      { new: true }
    );

    if (!video) {
      return res.status(404).json({
        success: false,
        message: "Video not found",
      });
    }

    res.json({
      success: true,
      data: video,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error incrementing view count",
    });
  }
};

// Get my videos (user's own videos)
export const getMyVideos = async (req, res) => {
  try {
    // Get user's page ID from the authenticated user
    const Page = (await import("../page/page.model.js")).default;
    const userPage = await Page.findOne({ userId: req.user._id }); // FIXED: Changed from req.user.userId to req.user._id

    if (!userPage) {
      return res.status(404).json({
        success: false,
        message: "User page not found",
      });
    }

    const videos = await Video.find({ pageId: userPage._id })
      .populate("pageId", "name")
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: videos.length,
      data: videos,
    });
  } catch (error) {
    console.error("Error fetching my videos:", error);
    res.status(500).json({
      success: false,
      message: "Error fetching your videos",
    });
  }
};



// Get single video
export const getVideo = async (req, res) => {
  try {
    const video = await Video.findById(req.params.id).populate(
      "pageId",
      "name description"
    );

    if (!video) {
      return res.status(404).json({
        success: false,
        message: "Video not found",
      });
    }

    res.json({
      success: true,
      data: video, // Contains Backblaze URLs
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error fetching video",
    });
  }
};

// Delete video
export const deleteVideo = async (req, res) => {
  try {
    const video = await Video.findById(req.params.id);

    if (!video) {
      return res.status(404).json({
        success: false,
        message: "Video not found",
      });
    }

    // Verify ownership - get user's page and check if it matches video's pageId
    const Page = (await import("../page/page.model.js")).default;
    const userPage = await Page.findOne({ userId: req.user._id });

    if (!userPage) {
      return res.status(404).json({
        success: false,
        message: "User page not found",
      });
    }

    // Check if the video belongs to the user's page
    if (video.pageId.toString() !== userPage._id.toString()) {
      return res.status(403).json({
        success: false,
        message: "You are not authorized to delete this video",
      });
    }

    // Extract file keys from URLs - FIXED
    const videoKey = video.videoUrl.split("/").slice(3).join("/"); // Get path after domain
    const thumbnailKey = video.thumbnailUrl
      ? video.thumbnailUrl.split("/").slice(3).join("/")
      : null;

    // Delete from Backblaze B2
    await deleteFromBackblaze(videoKey);
    if (thumbnailKey) {
      await deleteFromBackblaze(thumbnailKey);
    }

    // Delete from MongoDB
    await Video.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: "Video deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting video:", error);
    res.status(500).json({
      success: false,
      message: "Error deleting video",
      error: error.message,
    });
  }
};


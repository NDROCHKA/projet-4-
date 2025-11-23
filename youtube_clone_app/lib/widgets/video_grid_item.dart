import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../screens/video_player_screen.dart';

class VideoGridItem extends StatelessWidget {
  final Video video;

  const VideoGridItem({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: video.videoUrl),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: video.thumbnailUrl.isNotEmpty
                  ? Image.network(
                      video.thumbnailUrl, // Temporarily direct URL for debugging
                      // 'http://localhost:3500/proxy?url=${Uri.encodeComponent(video.thumbnailUrl)}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        print("Error loading image: ${video.thumbnailUrl}");
                        print("Error details: $error");
                        print("Stack trace: $stackTrace");
                        return const Center(
                          child: Icon(Icons.broken_image, color: Colors.white54),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    )
                  : const Center(child: Icon(Icons.videocam, size: 50)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

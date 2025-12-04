import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../models/video_model.dart';
import '../widgets/video_grid_item.dart';
import 'upload_video_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  List<Video> _myVideos = [];
  bool _loadingVideos = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMyVideos();
  }

  Future<void> _fetchMyVideos() async {
    print('📱 ProfileScreen: Fetching my videos...');
    try {
      final videoData = await _apiService.getMyVideos();
      print('📱 ProfileScreen: Received ${videoData.length} videos');
      if (mounted) {
        setState(() {
          _myVideos = videoData.map((json) => Video.fromJson(json)).toList();
          _loadingVideos = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      print("📱 ProfileScreen: Error fetching my videos: $e");
      if (mounted) {
        setState(() {
          _loadingVideos = false;
          _errorMessage = e.toString();
        });
      }
    }
  }



  Future<void> _deleteVideo(String videoId, String videoTitle) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Video'),
        content: Text('Are you sure you want to delete "$videoTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading state
    setState(() => _isLoading = true);

    try {
      await _apiService.deleteVideo(videoId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video deleted successfully')),
        );
        _fetchMyVideos(); // Refresh video list
      }
    } catch (e) {
      print('Delete error in UI: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting video: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A0000), // Dark Red
                    Color(0xFF000000), // Black
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Theme(
                data: ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: Colors.transparent,
                  canvasColor: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    // Decorative background elements
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.03),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      left: -60,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.02),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      right: 30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withOpacity(0.05),
                        ),
                      ),
                    ),
                    // Main content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                  children: [
                    // Profile Image (circular)
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    
                    // Name
                    const Text(
                      'User Name',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Description
                    Text(
                      'This is a user description. It will be updated with real data from the backend.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Upload Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UploadVideoScreen()),
                        );
                        _fetchMyVideos();
                      },
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload New Video'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Videos section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Videos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_myVideos.length} videos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Videos grid
                    _loadingVideos
                        ? const Center(child: CircularProgressIndicator())
                        : _errorMessage != null
                            ? Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error loading videos:',
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _errorMessage!,
                                      style: TextStyle(color: Colors.grey[600]),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _fetchMyVideos,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : _myVideos.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Text(
                                      'No videos yet',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,           // 3 videos per row
                                      childAspectRatio: 0.8,       // Increased from 0.75 to make cards shorter
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 0,          // Reduced from 4 to 0
                                    ),
                                    itemCount: _myVideos.length,
                                    itemBuilder: (context, index) {
                                      final video = _myVideos[index];
                                      return Stack(
                                        children: [
                                          VideoGridItem(video: video),
                                          // Delete button overlay
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () => _deleteVideo(video.id, video.title),
                                                borderRadius: BorderRadius.circular(20),
                                                child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.withOpacity(0.9),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                  ],
                ),
              ),
            ),
                  ],
                ),
              ),
            ),
    );
  }
}

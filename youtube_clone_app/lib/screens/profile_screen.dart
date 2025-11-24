import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _showUploadDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    XFile? videoFile;
    XFile? thumbnailFile;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Upload Video'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
                          if (video != null) {
                            setState(() {
                              videoFile = video;
                            });
                          }
                        } catch (e) {
                          print('Error picking video: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error picking video: $e')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.video_library),
                      label: Text(videoFile != null ? 'Video Selected' : 'Pick Video'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: videoFile != null ? Colors.green : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              thumbnailFile = image;
                            });
                          }
                        } catch (e) {
                          print('Error picking image: $e');
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: Text(thumbnailFile != null ? 'Thumbnail Selected' : 'Pick Thumbnail'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: thumbnailFile != null ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty || videoFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title and Video are required')),
                      );
                      return;
                    }

                    Navigator.pop(context); // Close dialog
                    _uploadVideo(
                      titleController.text,
                      descriptionController.text,
                      videoFile!,
                      thumbnailFile,
                    );
                  },
                  child: const Text('Upload'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _uploadVideo(String title, String description, XFile video, XFile? thumbnail) async {
    setState(() => _isLoading = true);

    try {
      final pageId = await _apiService.getMyPageId();
      print('Retrieved Page ID: $pageId'); // Debug print

      if (pageId == null) {
        throw Exception('Could not get Page ID. Please try logging in again.');
      }

      await _apiService.uploadVideo(
        title,
        description,
        video,
        thumbnail,
        pageId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload Successful!')),
        );
      }
    } catch (e) {
      print('Upload error in UI: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}')),
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
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      onPressed: _showUploadDialog,
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload New Video'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Videos section
                    const Text(
                      'My Videos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Placeholder for videos
                    Expanded(
                      child: Center(
                        child: Text(
                          'No videos yet',
                          style: TextStyle(color: Colors.grey[600]),
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

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  XFile? _videoFile;
  XFile? _thumbnailFile;
  bool _isLoading = false;

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _videoFile = video;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking video: $e')),
        );
      }
    }
  }

  Future<void> _pickThumbnail() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _thumbnailFile = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _uploadVideo() async {
    if (_titleController.text.isEmpty || _videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Video are required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final pageId = await _apiService.getMyPageId();
      if (pageId == null) {
        throw Exception('Could not get Page ID. Please try logging in again.');
      }

      await _apiService.uploadVideo(
        _titleController.text,
        _descriptionController.text,
        _videoFile!,
        _thumbnailFile,
        pageId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload Successful!')),
        );
        Navigator.pop(context); // Return to previous screen
      }
    } catch (e) {
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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: Container(
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
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelStyle: const TextStyle(color: Colors.white70),
            ),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      
                      // Video Picker
                      InkWell(
                        onTap: _pickVideo,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _videoFile != null ? Colors.green : Colors.white30,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: _videoFile != null 
                                ? Colors.green.withOpacity(0.1) 
                                : Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _videoFile != null ? Icons.check_circle : Icons.video_library,
                                size: 48,
                                color: _videoFile != null ? Colors.green : Colors.white70,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _videoFile != null ? 'Video Selected' : 'Select Video',
                                style: TextStyle(
                                  color: _videoFile != null ? Colors.green : Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_videoFile != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _videoFile!.name,
                                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Thumbnail Picker
                      InkWell(
                        onTap: _pickThumbnail,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _thumbnailFile != null ? Colors.green : Colors.white30,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: _thumbnailFile != null 
                                ? Colors.green.withOpacity(0.1) 
                                : Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _thumbnailFile != null ? Icons.check_circle : Icons.image,
                                size: 48,
                                color: _thumbnailFile != null ? Colors.green : Colors.white70,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _thumbnailFile != null ? 'Thumbnail Selected' : 'Select Thumbnail (Optional)',
                                style: TextStyle(
                                  color: _thumbnailFile != null ? Colors.green : Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_thumbnailFile != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _thumbnailFile!.name,
                                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      ElevatedButton(
                        onPressed: _uploadVideo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Upload Video',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

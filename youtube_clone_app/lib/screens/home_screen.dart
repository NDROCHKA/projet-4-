import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/video_model.dart';
import '../widgets/video_grid_item.dart';
import '../providers/auth_provider.dart';
import 'search_results_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Video> _videos = [];
  List<Video> _popularVideos = [];
  List<Video> _recentVideos = [];
  List<Video> _filteredVideos = [];
  bool _isLoading = true;
  String _currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _updateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) => _updateTime());
    _fetchAllVideos();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  Future<void> _fetchAllVideos() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchVideos(),
      _fetchPopularVideos(),
      _fetchRecentVideos(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _fetchVideos() async {
    try {
      final videoData = await _apiService.getVideos();
      if (mounted) {
        setState(() {
          _videos = videoData.map((json) => Video.fromJson(json)).toList();
          _filteredVideos = _videos;
        });
      }
    } catch (e) {
      print("Error fetching videos: $e");
    }
  }

  Future<void> _fetchPopularVideos() async {
    try {
      final videoData = await _apiService.getPopularVideos();
      if (mounted) {
        setState(() {
          _popularVideos = videoData.map((json) => Video.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print("Error fetching popular videos: $e");
    }
  }

  Future<void> _fetchRecentVideos() async {
    try {
      final videoData = await _apiService.getRecentVideos();
      if (mounted) {
        setState(() {
          _recentVideos = videoData.map((json) => Video.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print("Error fetching recent videos: $e");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('YouTube Clone'),
            const Spacer(),
            Text(
              _currentTime,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          if (!authProvider.isAuthenticated) ...[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFB71C1C),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Sign Up'),
            ),
            const SizedBox(width: 16),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.whatshot), text: 'Popular'),
            Tab(icon: Icon(Icons.schedule), text: 'Recent'),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildVideoGrid(_popularVideos),
          _buildVideoGrid(_recentVideos),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleUploadButtonPress(authProvider),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _handleUploadButtonPress(AuthProvider authProvider) {
    if (authProvider.isAuthenticated) {
      // Navigate to profile screen which has the upload functionality
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      // Show login prompt
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to login to upload videos. Would you like to login now?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
    }
  }

  void _filterVideos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVideos = _videos;
      } else {
        _filteredVideos = _videos
            .where(
              (video) =>
                  video.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: _filterVideos,
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsScreen(
                      query: query,
                      results: _filteredVideos,
                    ),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              hintText: 'Search videos...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredVideos.isEmpty
              ? const Center(child: Text('No videos found'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _filteredVideos.length,
                  itemBuilder: (context, index) {
                    return VideoGridItem(video: _filteredVideos[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildVideoGrid(List<Video> videos) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (videos.isEmpty) {
      return const Center(child: Text('No videos found'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return VideoGridItem(video: videos[index]);
      },
    );
  }

  Widget _buildDrawer() {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.play_circle_filled, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'YouTube Clone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          if (authProvider.isAuthenticated) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                authProvider.logout();
                Navigator.pop(context); // Close drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

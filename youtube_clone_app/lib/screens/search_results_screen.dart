import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../widgets/video_grid_item.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  final List<Video> results;

  const SearchResultsScreen({
    super.key,
    required this.query,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search: "$query"'),
      ),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No videos found for "$query"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 16 / 9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                return VideoGridItem(video: results[index]);
              },
            ),
    );
  }
}

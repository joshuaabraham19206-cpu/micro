import 'package:flutter/material.dart';

// This is the new screen that shows the content for a specific resource.
class ResourceDetailScreen extends StatelessWidget {
  final String title;
  final String type;
  final String content;

  const ResourceDetailScreen({
    super.key,
    required this.title,
    required this.type,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // We use a ListView to ensure the content can scroll if it's long
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // --- Custom Header ---
          Text(
            type.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontSize: 26),
          ),
          const Divider(height: 30),

          // --- Smart Content Widget ---
          // This widget build the UI based on the resource type
          _buildContent(context),
        ],
      ),
    );
  }

  // This helper method checks the 'type' and builds the correct UI
  Widget _buildContent(BuildContext context) {
    // --- VIDEO PLAYER UI ---
    if (type.contains('Video')) {
      return Column(
        children: [
          Text(
            "Here is the video you requested. Tap to play.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          // --- This is our "Fake Video Player" ---
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16.0),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://placehold.co/600x400/76b8b8/white?text=Exam+Stress+Video',
                ),
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white.withOpacity(0.9),
                size: 70,
              ),
            ),
          ),
        ],
      );
    }
    // --- ARTICLE UI ---
    else if (type.contains('Article')) {
      return Text(
        content, // Display the long placeholder text
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    // --- AUDIO/EXERCISE UI ---
    else {
      return Column(
        children: [
          Text(
            "This is a guided audio exercise. Press play to begin.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play Audio'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          ),
        ],
      );
    }
  }
}

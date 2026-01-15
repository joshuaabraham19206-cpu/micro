import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// This is the new screen that shows the content for a specific resource.
class ResourceDetailScreen extends StatefulWidget {
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
  State<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  YoutubePlayerController? _youtubeController;
  String _videoId = '';

  @override
  void initState() {
    super.initState();

    // --- VIDEO RESOURCES ---
    if (widget.type.contains('Video')) {
      if (widget.title == 'Managing Exam Stress') {
        _videoId = '-RZ86OB9hw4';
      } else if (widget.title == 'Building Resilience') {
        _videoId = 'GLAdRgft7pU';
      }
    }

    // --- AUDIO / EXERCISE RESOURCES ---
    else if (widget.type.contains('Audio') ||
        widget.type.contains('Exercise')) {
      if (widget.title == 'Guided Morning Meditation') {
        _videoId = 'FGO8IWiusJo';
      } else if (widget.title == '5-Minute Mindful Breathing') {
        _videoId = 'DbDoBzGY3vo';
      }
    }

    // Initialize YouTube controller ONLY for mobile platforms
    if (_videoId.isNotEmpty && !kIsWeb) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: _videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          hideControls: false,
          showLiveFullscreenButton: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            widget.type.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 26),
          ),
          const Divider(height: 30),
          _buildContent(context),
        ],
      ),
    );
  }

  // Helper method to build content based on type
  Widget _buildContent(BuildContext context) {
    // --- VIDEO UI ---
    if (widget.type.contains('Video')) {
      if (_videoId.isEmpty) {
        return const Text("Video unavailable.");
      }

      // WEB → Open YouTube externally
      if (kIsWeb) {
        return ElevatedButton.icon(
          onPressed: () async {
            final uri =
                Uri.parse('https://www.youtube.com/watch?v=$_videoId');
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
          icon: const Icon(Icons.play_circle_fill),
          label: const Text('Open Video on YouTube'),
        );
      }

      // ANDROID / IOS → Embedded Player
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
        ),
      );
    }

    // --- ARTICLE UI ---
    else if (widget.type.contains('Article')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse(
                'https://www.psychologytoday.com/us/basics/anxiety',
              );
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Read Full Article'),
          ),
        ],
      );
    }

    // --- AUDIO / EXERCISE UI ---
    else {
      if (_videoId.isEmpty) {
        return const Text("Audio unavailable.");
      }

      return Column(
        children: [
          Text(
            "This is a guided audio exercise. Press play to begin.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              // WEB → Open YouTube externally
              if (kIsWeb) {
                final uri =
                    Uri.parse('https://www.youtube.com/watch?v=$_videoId');
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              }
              // ANDROID / IOS → Play audio
              else {
                _youtubeController?.play();
              }
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play Audio'),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          ),
        ],
      );
    }
  }
}





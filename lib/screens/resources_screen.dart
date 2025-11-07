import 'package:flutter/material.dart';
// *** ADD THIS IMPORT ***
// We need to import the new detail screen we just created.
import 'package:micro/screens/resource_detail_screen.dart';

// --- SCREEN 2: RESOURCES ---
class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  // *** UPDATED: Mock data now includes 'content' for each resource ***
  final List<Map<String, dynamic>> resources = const [
    {
      'icon': Icons.videocam,
      'title': 'Managing Exam Stress',
      'type': 'Video • 12 min',
      'content': 'This is a placeholder for the exam stress video.',
    },
    {
      'icon': Icons.graphic_eq,
      'title': 'Guided Morning Meditation',
      'type': 'Audio • 10 min',
      'content': 'This is a placeholder for the meditation audio.',
    },
    {
      'icon': Icons.article,
      'title': 'Understanding Anxiety',
      'type': 'Article • 8 min read',
      'content':
          'Anxiety is a feeling of worry, nervousness, or unease, typically about an imminent event or something with an uncertain outcome...\n\n(This is placeholder text. In a real app, this article would be much longer and would be loaded from a database or API.)\n\nCommon symptoms include:\n• Feeling nervous, restless or tense\n• Having a sense of impending danger, panic or doom\n• Having an increased heart rate\n• Breathing rapidly (hyperventilation)\n\nIt is important to remember that you are not alone and help is available. Talk to someone you trust or seek professional help.',
    },
    {
      'icon': Icons.spa,
      'title': '5-Minute Mindful Breathing',
      'type': 'Exercise • 5 min',
      'content': 'This is a placeholder for the breathing exercise.',
    },
    {
      'icon': Icons.self_improvement,
      'title': 'Building Resilience',
      'type': 'Video • 15 min',
      'content': 'This is a placeholder for the resilience video.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resource Hub',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        // Use the length of our new resource list
        itemCount: resources.length,
        itemBuilder: (BuildContext context, int index) {
          // Get the data for the current item
          final resource = resources[index];

          return Card(
            child: ListTile(
              leading: Icon(
                resource['icon'] as IconData,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              title: Text(
                resource['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(resource['type'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              // *** UPDATED with navigation logic ***
              onTap: () {
                // Navigate to the detail screen and pass the resource data
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResourceDetailScreen(
                      title: resource['title'],
                      type: resource['type'],
                      content: resource['content'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

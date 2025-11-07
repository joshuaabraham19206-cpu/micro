import 'package:flutter/material.dart';

// --- SCREEN 4: COMMUNITY ---
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peer Support Network', style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
            tooltip: 'Create a new post',
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          final posts = [
            {
              'author': 'Anonymous Koala',
              'post': 'Feeling really overwhelmed with final exams coming up. Any tips on how to stay calm and focused?'
            },
            {
              'author': 'Brave Badger',
              'post': 'Just had a really good session with a counselor I booked through the app. It really does help to talk to someone.'
            },
            {
              'author': 'Hopeful Heron',
              'post': 'What are some small things you do every day to feel better? I\'m trying to build a routine.'
            },
          ];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(posts[index]['author']!, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  const SizedBox(height: 8),
                  Text(posts[index]['post']!, style: Theme.of(context).textTheme.bodyMedium),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildReactionButton(Icons.favorite_border, 'Support'),
                      _buildReactionButton(Icons.comment_outlined, 'Comment'),
                      _buildReactionButton(Icons.share_outlined, 'Share'),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper widget for reaction buttons to keep the code clean.
  Widget _buildReactionButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20, color: Colors.grey[700]),
      label: Text(label, style: TextStyle(color: Colors.grey[700])),
    );
  }
}

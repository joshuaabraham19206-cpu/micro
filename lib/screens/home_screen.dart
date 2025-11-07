import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- UPDATED IMPORTS ---
// Make sure to import all the screens we need
import 'package:micro/screens/meditation_screen.dart';
import 'package:micro/screens/chat_screen.dart';
import 'package:micro/screens/journaling_screen.dart';
import 'package:micro/screens/breathing_screen.dart'; // We need this one too!

// --- SCREEN 1: HOME ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SafeArea ensures that the app's content is not obscured by system UI
    // like the notch on an iPhone or the status bar.
    return SafeArea(
      // We use a ListView to allow content to scroll if it overflows the screen.
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Greeting text
          Text(
            'Good Morning,',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18),
          ),
          Text(
            'How are you feeling today?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),

          // Main Call-to-Action Card for the AI Chatbot
          Card(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI First Aid',
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Talk to our interactive chatbot for instant coping support. It\'s safe and available 24/7.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ChatScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Start a Conversation'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Section for quick actions
          Text(
            'Quick Tools',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- ADDED BREATHING CARD BACK ---
              _buildQuickToolCard(
                context,
                Icons.spa, // Breathing icon
                'Breathing', // Breathing label
                Theme.of(context).colorScheme.secondary,
              ),
              _buildQuickToolCard(
                context,
                Icons.edit,
                'Journaling',
                Theme.of(context).primaryColor,
              ),
              _buildQuickToolCard(
                context,
                Icons.self_improvement,
                'Meditation',
                Colors.orange.shade300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- UPDATED HELPER WIDGET ---
  // A helper widget to build the small tool cards.
  // It's now wrapped in an InkWell to make the whole card tappable.
  Widget _buildQuickToolCard(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 0,
        // Wrap the contents in an InkWell to make it tappable
        child: InkWell(
          onTap: () {
            // --- NAVIGATION LOGIC ---
            // We check the label to decide which screen to open
            if (label == 'Breathing') {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BreathingScreen()),
              );
            } else if (label == 'Journaling') {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const JournalingScreen()),
              );
            } else if (label == 'Meditation') {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MeditationScreen()),
              );
            }
          },
          borderRadius: BorderRadius.circular(16), // Match Card's border radius
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
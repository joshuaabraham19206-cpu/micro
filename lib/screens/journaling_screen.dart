import 'package:flutter/material.dart';

class JournalingScreen extends StatefulWidget {
  const JournalingScreen({super.key});

  @override
  State<JournalingScreen> createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  final TextEditingController _journalController = TextEditingController();

  void _saveEntry() {
    // In a real app, you would save this to a database.
    // For this demo, we'll just show a confirmation SnackBar.
    if (_journalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Your entry is empty.'),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    // Hide keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your entry has been saved!'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );

    // Clear the text field after saving
    _journalController.clear();
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal', style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            "What's on your mind today?",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 22,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Writing down your thoughts can help bring clarity and peace.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          // --- Journal Entry Text Field ---
          TextField(
            controller: _journalController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 15, // Gives plenty of space to write
            decoration: InputDecoration(
              hintText: 'Start writing here...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // --- Save Button ---
          ElevatedButton(
            onPressed: _saveEntry,
            child: const Text('Save Entry'),
          ),
        ],
      ),
    );
  }
}
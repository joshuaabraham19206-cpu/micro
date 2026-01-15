import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalingScreen extends StatefulWidget {
  const JournalingScreen({super.key});

  @override
  State<JournalingScreen> createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  final TextEditingController _journalController = TextEditingController();
  List<String> _savedJournals = [];

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  /// Load saved journals from local storage
  Future<void> _loadJournals() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _savedJournals = prefs.getStringList('journals') ?? [];
    });
  }

  /// Save journal entry permanently
  Future<void> _saveEntry() async {
    final text = _journalController.text.trim();

    if (text.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Your entry is empty.'),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _savedJournals.insert(0, text);
    });

    await prefs.setStringList('journals', _savedJournals);

    _journalController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your entry has been saved!'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  /// 🗑 Delete a journal entry
  Future<void> _deleteEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _savedJournals.removeAt(index);
    });

    await prefs.setStringList('journals', _savedJournals);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal entry deleted')),
    );
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
        title: Text(
          'Journal',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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

          /// Journal Input
          TextField(
            controller: _journalController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 8,
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

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: _saveEntry,
            child: const Text('Save Entry'),
          ),

          const SizedBox(height: 32),

          /// Saved Journals Section
          Text(
            'Saved Journals',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          if (_savedJournals.isEmpty)
            const Text('No journal entries yet.')
          else
            ..._savedJournals.asMap().entries.map(
              (entry) {
                final index = entry.key;
                final text = entry.value;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(text),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red.shade400,
                      onPressed: () => _deleteEntry(index),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

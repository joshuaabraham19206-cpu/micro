import 'dart:convert'; // Added for JSON encoding/decoding
import 'dart:math'; // *** ADDED for random replies ***
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Added for making API calls

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // --- STATE VARIABLES ---

  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  // IMPORTANT: Replace this with your actual Groq API key
  // Your key should be kept secret and not hardcoded in a real app.
  // Consider using environment variables (e.g., flutter_dotenv).
  final String _groqApiKey =
      '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';

  // --- FIX: Updated the model name ---
  // final String _model = 'llama3-8b-8192'; // This model is decommissioned
  final String _model = 'llama3-70b-8192'; // Using a current, supported model
  // --- End Fix ---

  final String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  bool _isLoading = false; // To show a loading indicator

  // *** UPDATED: List of empathetic fallback replies ***
  // This is now a structured Map based on your provided list
  final Map<String, List<String>> _smartFallbackReplies = {
    'happy': [
      "That's wonderful to hear! What made today special for you?",
      "I'm glad you're feeling good. Would you like to talk more about what's making you happy?",
      "It's great to sense your joy! Is there anything you'd like to celebrate?",
      "Your happiness is important. Keep focusing on the things that lift you up!",
    ],
    'sad': [
      "I'm sorry you're feeling this way. Do you want to share what's on your mind?",
      "It's okay to feel sad sometimes. I'm here if you want to talk or just need someone to listen.",
      "Would you like to talk about what's making you feel down right now?",
      "Remember, you don't have to go through this alone. I'm here for you.",
    ],
    'angry': [
      "It sounds like something really upset you. Would talking about it help?",
      "Your feelings are valid. Do you want to share more about what's making you angry?",
      "I'm here to listen if you need to vent or process your frustration.",
      "Anger is a natural response. How can I assist you in finding some relief?",
    ],
    'anxious': [
      "It's normal to feel anxious sometimes. Do you want to talk about what's worrying you?",
      "Would a calming exercise help you right now, or would you like to share your thoughts?",
      "I'm here for you—let's take things one step at a time.",
      "If your mind is racing, we can try breathing together. Would you like that?",
    ],
    'lonely': [
      "It can be tough feeling alone. Remember, you're not alone while we're talking.",
      "Would you like to talk more about what’s making you feel this way?",
      "Sometimes sharing can help ease loneliness. I'm here to listen.",
      "You matter, and I'm glad you're here with me now.",
    ],
    'overwhelmed': [
      "When everything feels like too much, taking a pause can help. Want to try a short break together?",
      "I'm sorry things are overwhelming right now. Do you want to talk through what’s stressing you out?",
      "Breaking things down into smaller steps often helps. Want to try that together?",
      "Remember, you're doing your best. It's okay to ask for help.",
    ],
    'hopeful': [
      "That's wonderful you feel hopeful. Would you like to talk about what’s making you positive?",
      "Optimism brings strength. Anything you’re looking forward to that you’d like to share?",
      "Your positive outlook can be inspiring. Is there a new goal you're excited about?",
      "Hope can be powerful during tough times. Keep holding onto it!",
    ],
    'confused': [
      "Feeling uncertain is normal. Want to talk through your options together?",
      "It’s okay to feel conflicted. Maybe sharing will help bring some clarity.",
      "If things are unclear, I'm here to help you sort through your thoughts.",
      "Would making a list of your thoughts help you feel more organized?",
    ],
    'grateful': [
      "I'm glad something made you feel grateful! Would you like to talk more about it?",
      "It's wonderful to recognize good things in life. What are you most thankful for today?",
      "Gratitude can be uplifting. Is there someone you'd like to thank, or a moment you cherish?",
      "Focusing on gratitude can improve mood. Let's reflect on what went well today together.",
    ],
    'proud': [
      "That’s awesome! Would you like to share what you’re proud of?",
      "Celebrating achievements is important. How did you reach this goal?",
      "I'm happy to see your progress. Every step forward matters.",
      "Acknowledging your accomplishments can boost confidence. Well done!",
    ],
    'default': [
      "I'm sorry, I'm having trouble connecting right now. Please know that your feelings are valid and you can try again in a moment.",
      "It seems my connection is down. Remember, it's okay to feel sad or frustrated sometimes. Please check your connection.",
      "I can't seem to connect. If you're feeling anxious, how about a calming exercise? We have one on the 'Home' screen.",
    ],
  };

  // *** ADDED: Keyword map to link words to categories ***
  final Map<String, String> _keywordMap = {
    'happy': 'happy',
    'joyful': 'happy',
    'great': 'happy',
    'wonderful': 'happy',
    'glad': 'happy',
    'sad': 'sad',
    'down': 'sad',
    'crying': 'sad',
    'upset': 'sad',
    'miserable': 'sad',
    'angry': 'angry',
    'frustrated': 'angry',
    'mad': 'angry',
    'pissed': 'angry',
    'furious': 'angry',
    'anxious': 'anxious',
    'worried': 'anxious',
    'nervous': 'anxious',
    'scared': 'anxious',
    'lonely': 'lonely',
    'isolated': 'lonely',
    'alone': 'lonely',
    'overwhelmed': 'overwhelmed',
    'stressed': 'overwhelmed',
    'hopeful': 'hopeful',
    'optimistic': 'hopeful',
    'confused': 'confused',
    'uncertain': 'confused',
    'unsure': 'confused',
    'grateful': 'grateful',
    'thankful': 'grateful',
    'proud': 'proud',
    'accomplished': 'proud',
  };

  // *** UPDATED: Helper function to get a random reply based on keywords ***
  String _getSmartFallbackReply(String userMessage) {
    final random = Random();
    String message = userMessage.toLowerCase();
    String matchedCategory = 'default'; // Default to 'default'

    // Find the first keyword that matches
    for (String keyword in _keywordMap.keys) {
      if (message.contains(keyword)) {
        matchedCategory =
            _keywordMap[keyword]!; // Get the category (e.g., 'sad')
        break; // Stop at the first match
      }
    }

    // Get the list of replies for that category
    List<String> replies =
        _smartFallbackReplies[matchedCategory] ??
        _smartFallbackReplies['default']!;

    // Return a random reply from that list
    return replies[random.nextInt(replies.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- SEND MESSAGE FUNCTION (MODIFIED FOR API) ---

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Add the user's message to the UI immediately
    setState(() {
      _messages.insert(0, _ChatMessage(text: text, isUser: true));
      _isLoading = true; // Show loading indicator
    });
    _controller.clear();

    // 2. Prepare the message history for the API
    // Groq (and OpenAI) API expects messages in chronological order
    final apiMessages = _messages
        .map(
          (msg) => {
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.text,
          },
        )
        .toList()
        .reversed // Convert from ListView's reverse order
        .toList();

    // 3. Prepare the API request
    final headers = {
      'Authorization': 'Bearer $_groqApiKey',
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'model': _model,
      'messages': apiMessages,
      'temperature': 0.7,
    });

    // 4. Make the API call with error handling
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      String reply;
      if (response.statusCode == 200) {
        // Success: Parse the response
        final data = json.decode(response.body);
        reply = data['choices'][0]['message']['content'];
      } else {
        // Error: Show the error message
        // *** UPDATED: Use smart fallback reply ***
        reply = _getSmartFallbackReply(text);
      }

      // 5. Add the AI's reply to the UI
      setState(() {
        _messages.insert(0, _ChatMessage(text: reply, isUser: false));
      });
    } catch (e) {
      // Network or other errors
      // Removed the print statements as we've found the error.
      // *** UPDATED: Use smart fallback reply ***
      setState(() {
        _messages.insert(
          0,
          _ChatMessage(
            text: _getSmartFallbackReply(text), // Use the smart fallback reply
            isUser: false,
          ), // New generic message
        );
      });
    } finally {
      // 6. Hide the loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- BUILD METHOD (MODIFIED FOR LOADING INDICATOR) ---

  @override
  Widget build(BuildContext context) {
    // This responsiveness check was already in your code - great!
    final isLarge = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat Support'), centerTitle: true),
      // *** FIX: Add this property ***
      // This prevents the Scaffold's body from resizing when the keyboard appears,
      // stopping the chat view from shrinking and "going up".
      resizeToAvoidBottomInset: false,
      // *** End Fix ***
      body: SafeArea(
        child: Column(
          children: [
            // --- CHAT MESSAGES LIST ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                  reverse: true, // Shows latest messages at the bottom
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    // This logic makes chat bubbles align left/right
                    return Align(
                      alignment: msg.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        // This constraint ensures messages don't get too wide
                        // and wrap nicely, which is great for responsiveness.
                        constraints: BoxConstraints(
                          maxWidth: isLarge
                              ? 600
                              : MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: Card(
                          color: msg.isUser
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isUser
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // --- LOADING INDICATOR ---
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'AI is typing...',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

            // --- TEXT INPUT AREA ---
            Container(
              color: Theme.of(context).cardColor,
              // This padding ensures the keyboard doesn't hide the input
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _sendMessage,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, // Increased padding
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Send button
                    FloatingActionButton(
                      onPressed: () => _sendMessage(_controller.text),
                      mini: true,
                      elevation: 1,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HELPER CLASS FOR MESSAGE DATA ---
class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

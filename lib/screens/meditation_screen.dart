import 'dart:async'; // Required for the Timer
import 'package:flutter/material.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  static const int _initialDuration = 300; // 5 minutes in seconds
  int _secondsRemaining = _initialDuration;
  bool _isRunning = false;
  Timer? _timer;

  // Formats seconds into a MM:SS string
  String get _timerDisplay {
    final int minutes = _secondsRemaining ~/ 60;
    final int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startPauseTimer() {
    if (_isRunning) {
      // Pause logic
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      // Start logic
      if (_secondsRemaining == 0) return; // Don't start if finished

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          // Timer finished
          _timer?.cancel();
          setState(() {
            _isRunning = false;
          });
          // Optional: Add a sound or "Done!" message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Meditation complete! Well done.'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      });
      setState(() {
        _isRunning = true;
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = _initialDuration;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure the timer is cancelled when the screen is left
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation', style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Calming Visual ---
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.shade300.withOpacity(0.2),
              ),
              child: Center(
                child: Icon(
                  Icons.self_improvement,
                  size: 100,
                  color: Colors.orange.shade400,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // --- Timer Display ---
            Text(
              _timerDisplay,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 72, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 10),
            Text(
              '5-Minute Calm',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 40),
            // --- Control Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- Reset Button ---
                IconButton(
                  icon: const Icon(Icons.refresh),
                  iconSize: 30,
                  color: Colors.grey[700],
                  onPressed: _resetTimer,
                ),
                const SizedBox(width: 20),
                // --- Start/Pause Button ---
                FloatingActionButton.large(
                  onPressed: _startPauseTimer,
                  backgroundColor: Colors.orange.shade400,
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                // Placeholder to balance the row
                const SizedBox(width: 30),
              ],
            )
          ],
        ),
      ),
    );
  }
}
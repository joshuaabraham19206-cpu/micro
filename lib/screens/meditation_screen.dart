import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  static const int _initialDuration = 300;
  int _secondsRemaining = _initialDuration;
  bool _isRunning = false;
  Timer? _timer;

  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();

    _youtubeController = YoutubePlayerController(
      initialVideoId: 'nkqnuxKj8Dk',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
        disableDragSeek: true,
        loop: true,
      ),
    );
  }

  String get _timerDisplay {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startPauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _youtubeController.pause();
      setState(() => _isRunning = false);
    } else {
      if (_secondsRemaining == 0) return;

      _youtubeController.play();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          timer.cancel();
          _youtubeController.pause();
          _youtubeController.seekTo(Duration.zero);

          setState(() => _isRunning = false);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Meditation complete! Well done.'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      });

      setState(() => _isRunning = true);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _youtubeController.pause();
    _youtubeController.seekTo(Duration.zero);

    setState(() {
      _secondsRemaining = _initialDuration;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _youtubeController.dispose();
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
      body: Column(
        children: [
          /// Hidden YouTube Player (audio only)
          SizedBox(
            height: 0,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _youtubeController,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // ✅ FIXED: no withOpacity warning
                      color: Colors.orange.shade300.withAlpha(51),
                    ),
                    child: Icon(
                      Icons.self_improvement,
                      size: 100,
                      color: Colors.orange.shade400,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _timerDisplay,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 72, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        iconSize: 30,
                        onPressed: _resetTimer,
                      ),
                      const SizedBox(width: 20),
                      FloatingActionButton.large(
                        onPressed: _startPauseTimer,
                        backgroundColor: Colors.orange.shade400,
                        child: Icon(
                          _isRunning ? Icons.pause : Icons.play_arrow,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

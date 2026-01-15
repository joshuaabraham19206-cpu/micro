import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late YoutubePlayerController _youtubeController;

  static const Duration sessionDuration = Duration(minutes: 2);
  Timer? _sessionTimer;

  bool _isRunning = false;
  String _instruction = "Ready";

  @override
  void initState() {
    super.initState();

    /// Breathing animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // 4s in, 4s hold, 4s out
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 50.0, end: 150.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 33.3,
      ),
      TweenSequenceItem(
        tween: ConstantTween(150.0),
        weight: 33.3,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 150.0, end: 50.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 33.3,
      ),
    ]).animate(_controller);

    /// Instruction updates
    _controller.addListener(() {
      final v = _controller.value;
      if (!mounted) return;

      setState(() {
        if (v < 0.33) {
          _instruction = "Breathe In";
        } else if (v < 0.66) {
          _instruction = "Hold";
        } else {
          _instruction = "Breathe Out";
        }
      });
    });

    /// Loop animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isRunning) {
        _controller.repeat();
      }
    });

    /// YouTube audio controller
    _youtubeController = YoutubePlayerController(
      initialVideoId: 'aIIEI33EUqI',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        hideControls: true,
        disableDragSeek: true,
        loop: true,
      ),
    );
  }

  void _startSession() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _instruction = "Breathe In";
    });

    _controller.forward(from: 0);
    _youtubeController.play();

    _sessionTimer = Timer(sessionDuration, _stopSession);
  }

  void _stopSession() {
    _sessionTimer?.cancel();
    _controller.stop();
    _controller.reset();

    _youtubeController.pause();
    _youtubeController.seekTo(Duration.zero);

    if (!mounted) return;

    setState(() {
      _isRunning = false;
      _instruction = "Session Complete 🌿";
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _controller.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Breathing Exercise",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          /// Hidden YouTube player (audio only)
          SizedBox(
            height: 0,
            child: YoutubePlayer(controller: _youtubeController),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (_, __) {
                      return Container(
                        width: _animation.value * 2,
                        height: _animation.value * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context)
                              .primaryColor
                              .withAlpha(180), // avoids withOpacity warning
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  Text(
                    _instruction,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isRunning ? null : _startSession,
                    child: const Text("Start 2-Minute Session"),
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

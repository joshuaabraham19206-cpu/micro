import 'package:flutter/material.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

// We use SingleTickerProviderStateMixin to power the AnimationController
class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String _instruction = "Get Ready..."; // Text to guide the user

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // Full cycle: 4s in, 4s hold, 4s out
    );

    // We use a TweenSequence to create a more complex animation:
    // 1. Grow (Breathe In)
    // 2. Stay large (Hold)
    // 3. Shrink (Breathe Out)
    _animation = TweenSequence<double>([
      // Breathe In (0% to 33% of animation)
      TweenSequenceItem(
          tween: Tween<double>(begin: 50.0, end: 150.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 33.3),
      // Hold (33% to 66% of animation)
      TweenSequenceItem(tween: ConstantTween<double>(150.0), weight: 33.3),
      // Breathe Out (66% to 100% of animation)
      TweenSequenceItem(
          tween: Tween<double>(begin: 150.0, end: 50.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 33.3),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat(); // Loop the animation
      }
    });

    // Listen to the animation value to update the instruction text
    _controller.addListener(() {
      final double value = _controller.value;
      setState(() {
        if (value < 0.33) {
          _instruction = "Breathe In";
        } else if (value < 0.66) {
          _instruction = "Hold";
        } else {
          _instruction = "Breathe Out";
        }
      });
    });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose of controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Breathing Exercise",
            style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedBuilder is the most efficient way to build an animation
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: _animation.value * 2,
                  height: _animation.value * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            Text(
              _instruction,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:personality/view/question_view.dart';
import 'package:personality/view/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _colorAnimation = _controller.drive(
      TweenSequence<Color?>(
        [
          TweenSequenceItem(
            tween: ColorTween(begin: Colors.red, end: Colors.blue),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: ColorTween(begin: Colors.blue, end: Colors.green),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: ColorTween(begin: Colors.green, end: Colors.yellow),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: ColorTween(begin: Colors.yellow, end: Colors.red),
            weight: 1,
          ),
        ],
      ),
    );

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) => CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color?>(_colorAnimation.value),
                strokeWidth: 4.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

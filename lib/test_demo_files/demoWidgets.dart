import 'package:flutter/material.dart';

class ProgressBarWidget extends StatefulWidget {
  final double progressValue;

  ProgressBarWidget({required this.progressValue});

  @override
  _ProgressBarWidgetState createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Animation duration
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progressValue).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ProgressBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progressValue != widget.progressValue) {
      _controller.duration = Duration(milliseconds: ((widget.progressValue - _animation.value) * 500).abs().round());
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: Text(
              'Downloading...', // Example text
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double progress1 = 0.6;
  double progress2 = 0.9;
  double progress3 = 0.1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Progress Bar Demo'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressBarWidget(progressValue: progress1),
            const SizedBox(height: 20),
            ProgressBarWidget(progressValue: progress2),
            const SizedBox(height: 20),
            ProgressBarWidget(progressValue: progress3),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  progress1 = 0.8; // Example update for progress1
                  progress2 = 0.2; // Example update for progress2
                  progress3 = 0.5; // Example update for progress3
                });
              },
              child: const Text('Update Progress'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

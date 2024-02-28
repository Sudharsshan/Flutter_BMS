import 'package:flutter/material.dart';

class ProgressBarWidget extends StatefulWidget {
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
      duration: Duration(seconds: 3), // Duration for one cycle of animation (from empty to full)
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset(); // Reset the animation when it's completed to create a loop
          _controller.forward();
        }
      });
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity, // Full width
          height: 40, // Increased height for a thicker progress bar
          decoration: BoxDecoration(
            color: Colors.grey[300], // Background color of the progress bar container
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value, // Use the animated value for the width factor
            child: Container(
              height: 40, // Increased height for a thicker progress bar
              decoration: BoxDecoration(
                color: Colors.blue, // Color of the progress bar
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
            ),
          ),
        ),
        Positioned(
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

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Progress Bar Demo'),
      ),
      body: Center(
        child: ProgressBarWidget(),
      ),
    ),
  ));
}

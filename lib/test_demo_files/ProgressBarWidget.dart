import 'package:batterymanagementsystem/theme.dart';
import 'package:flutter/material.dart';

class ProgressBarWidget extends StatefulWidget {
  @override
  _ProgressBarWidgetState createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller1, _controller2, _controller3;
  late Animation<double> _animation1, _animation2, _animation3;

  @override
  void initState() {
    super.initState();

    //Widget 1
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Duration for one cycle of animation (from empty to full)
    );
    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(_controller1)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller1.reset(); // Reset the animation when it's completed to create a loop
          _controller1.forward();
        }
      });
    _controller1.forward(); // Start the animation

    //Widget 2
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Duration for one cycle of animation (from empty to full)
    );
    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(_controller2)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller2.reset(); // Reset the animation when it's completed to create a loop
          _controller2.forward();
        }
      });
    _controller2.forward(); // Start the animation

    //Widget 3
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600), // Duration for one cycle of animation (from empty to full)
    );
    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(_controller3)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller3.reset(); // Reset the animation when it's completed to create a loop
          _controller3.forward();
        }
      });
    _controller3.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller1.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity, // Full width
                height: 80, // Increased height for a thicker progress bar
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), //change this value as per your choice for making neat looking widget
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Background color of the progress bar container
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _animation1.value, // Use the animated value for the width factor
                  child: Container(
                    height: 80, // Increased height for a thicker progress bar
                    decoration: BoxDecoration(
                      color: Colors.blue, // Color of the progress bar
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 25,
                left: 50,
                right: 0,
                bottom: 0,
                child: Text(
                  'Downloading...', // Example text
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                width: double.infinity, // Full width
                height: 80, // Increased height for a thicker progress bar
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), //change this value as per your choice for making neat looking widget
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Background color of the progress bar container
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _animation1.value, // Use the animated value for the width factor
                  child: Container(
                    height: 80, // Increased height for a thicker progress bar
                    decoration: BoxDecoration(
                      color: Colors.blue, // Color of the progress bar
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 25,
                left: 50,
                right: 0,
                bottom: 0,
                child: Text(
                  'Downloading...', // Example text
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeClass.lightTheme,
    darkTheme: ThemeClass.darkTheme,
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

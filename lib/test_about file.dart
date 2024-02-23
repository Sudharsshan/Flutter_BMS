// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About Page Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AboutPage(),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Page'),
        backgroundColor: Colors.deepPurple[900], // Updated app bar color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description of the App',
              style: TextStyle(
                fontSize: 24.0, // Increased font size for a futuristic feel
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[900], // Updated text color
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your app description goes here. This is where you describe the purpose or main features of your app.',
              style: TextStyle(
                fontSize: 18.0, // Increased font size for better readability
                color: Colors.deepPurple[800], // Updated text color
              ),
            ),
            SizedBox(height: 32.0),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 24.0, // Increased font size for a futuristic feel
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[900], // Updated text color
              ),
            ),
            SizedBox(height: 16.0),
            FAQItem(
              question: 'Question 1?',
              answer: 'Answer to question 1.',
            ),
            FAQItem(
              question: 'Question 2?',
              answer: 'Answer to question 2.',
            ),
            FAQItem(
              question: 'Question 3?',
              answer: 'Answer to question 3.',
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple[900], // Updated text color
        ),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 16.0, // Increased font size for better readability
              color: Colors.deepPurple[800], // Updated text color
            ),
          ),
        ),
      ],
    );
  }
}

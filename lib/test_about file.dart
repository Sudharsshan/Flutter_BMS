import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.question,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple[900], // Updated text color
        ),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            widget.answer,
            style: TextStyle(
              fontSize: 16.0, // Increased font size for better readability
              color: Colors.deepPurple[800], // Updated text color
            ),
          ),
        ),
      ],
      onExpansionChanged: (expanded) {
        setState(() {
          _expanded = expanded;
        });
      },
      initiallyExpanded: _expanded,
    );
  }
}
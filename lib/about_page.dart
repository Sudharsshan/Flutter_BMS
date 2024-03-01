import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class about_page extends StatefulWidget {
  const about_page({super.key});

  @override
  State<about_page> createState() => _about_page();
}

class _about_page extends State<about_page>{
  /*
    This page contains the basic info of the app and the project.
   */
  bool isDarkMode = false; //Initially it is in dark mode

  @override
  void initState(){
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = pref.getBool('isDarkMode') ?? false;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle:true,
          title: const Text("About"),
          backgroundColor: const Color.fromARGB(255, 203, 147, 201),
          elevation: 30,
          foregroundColor: const Color.fromARGB(255, 116, 71, 138),
          shadowColor: Colors.black,
        ),

        drawer: Drawer(
          backgroundColor: Colors.deepPurple[200],
          child: Column(
            children: [
              const DrawerHeader(child: Column(
                children: [
                  Icon(Icons.settings, size: 80,color: Colors.black45,),
                  Text("BMS"),
                ],
              )),

              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("H O M E"),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'home');
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("S E T T I N G S"),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'settings');
                },
              ),

               ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text("A B O U T"),
                onTap: () {
                  //This isn't required as this is ABOUT page
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'about');
                },
              ),
            ],
          ),
        ),

        body: AboutPage(),
        ),
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
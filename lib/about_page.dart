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
                color: Colors.redAccent, // Update text color
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your app description goes here. This is where you describe the purpose or main features of your app.',
              style: TextStyle(
                fontSize: 18.0, // Increased font size for better readability
                color: Colors.green[800], // Update text color
              ),
            ),
            SizedBox(height: 32.0),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 24.0, // Increased font size for a futuristic feel
                fontWeight: FontWeight.bold,
                color: Colors.redAccent[900], // Update text color
              ),
            ),
            SizedBox(height: 16.0),
            FAQItem(
              question: 'Q: What is a self-driving electric vehicle (EV)?',
              answer: 'A self-driving electric vehicle'
                  ', commonly known as an EV, is an automobile that runs on electricity as its primary source'
                  ' of power and is equipped with autonomous driving capabilities. '
                  'These vehicles can navigate and operate on roads without human intervention, '
                  'relying on various sensors, cameras, and advanced software algorithms to detect and respond to their surroundings.',
            ),
            FAQItem(
              question: 'Q: What are the features of the app?',
              answer: 'Notifications and Alerts: Receive alerts about vehicle status, driving conditions, software updates, and maintenance reminders.'
                  'Vehicle Monitoring: Monitor the battery charge level, estimated range, and other important vehicle parameters in real-time. ',
            ),
            FAQItem(
              question: 'Q: Can I access battery health information remotely through the app?',
              answer: 'Yes, the app enables remote access to battery health information. Users can view real-time battery health data,'
                  ' receive notifications, and access historical information from anywhere,'
                  ' providing convenience and peace of mind.',
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
          color: Colors.green[900], // Updated text color
        ),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            widget.answer,
            style: TextStyle(
              fontSize: 16.0, // Increased font size for better readability
              color: Colors.lightGreenAccent[800], // Updated text color
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
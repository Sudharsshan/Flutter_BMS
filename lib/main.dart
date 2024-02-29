import 'package:batterymanagementsystem/about_page.dart';
import 'package:batterymanagementsystem/settings.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//This var stores data from the api response received
String responseData = 'Loading...';

//This is a background task executor which will execute a background task as long as you want
void callbackDispatcher() {
  print('Initialized callBackDispatcher');
    // Fetch data from API
    Workmanager().executeTask((taskName, link) async {
      //logic is here
      try {
        final fetchLink = Uri.parse(link as String);
        const apiKey = 'aio_fOIT54TDT5jDFxcL9HuByjJusqha'; // Replace with your API key

        final response = await http.get(
          fetchLink,
          headers: {
            'X-AIO-Key': apiKey, // Include API key in the request headers
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          //modify this part of the code to obtain the required data
          final lastValueFromResponse = data['last_value'];
          responseData = lastValueFromResponse.toString();
          print("Value is: $lastValueFromResponse");
        } else {
          responseData = 'Failed to fetch data: ${response.statusCode}';
        }

      } catch (error) {
        responseData = 'Error: $error';
      }
      return Future.value(true);
    });
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);

  // Register periodic task
  Workmanager().registerPeriodicTask(
    "fetchData",
    "fetchDataTask",
    frequency: const Duration(seconds: 10), // Fetch data every 10 minutes
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  //Rebuild the color of the app.
  //For the time being, only the structure of the app will be made which can be edited later after discussion with the team.

  bool isDarkMode = false; //Initially the app is in light mode

  //Initialises the shared_preferences for use into the app
  @override
  void initState(){
    super.initState();
    _loadTheme();
  }

  //This method will fetch the Theme value from the shared_preferences
  void _loadTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = pref.getBool('isDarkMode') ?? false;
    });
  }

  //This is the API link to fetch the data from web
  //You may add API Key if required
  final fetchLink = Uri.parse('https://io.adafruit.com/api/v2/SudharsshanSY/feeds/altitude');
  Future<void> fetchData() async {
    try {
      const apiKey = 'aio_fOIT54TDT5jDFxcL9HuByjJusqha'; // Replace with your API key

      final response = await http.get(
        fetchLink,
        headers: {
          'X-AIO-Key': apiKey, // Include API key in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lastValueFromResponse = data['last_value'];
        responseData = lastValueFromResponse.toString();
      } else {
        responseData = 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (error) {
      responseData = 'Error: $error';
    }
  }

//This method will create a scheduled task to be executed in the background at particular intervals as specified
  void scheduleTask(){
    Workmanager().registerPeriodicTask(
        'myTask',
        '$fetchLink',
        frequency: const Duration(minutes: 2),
        inputData: <String, dynamic>{'key': 'value'});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //To avoid the DEBUG banner
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      //App theme is set UNIVERSAL via this method
      home: Builder(
        builder: (BuildContext context) =>
            Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("BMS"),
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
                          Icon(Icons.settings, size: 80, color: Colors.black45,),
                          Text("BMS"),
                        ],
                      )),

                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text("H O M E"),
                        onTap: () {
                          Navigator.pushNamed(context, 'home');
                        },
                      ),

                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text("S E T T I N G S"),
                        onTap: () {
                          Navigator.pushNamed(context, 'settings');
                        },
                      ),

                      ListTile(
                        leading: const Icon(Icons.info_outline_rounded),
                        title: const Text("A B O U T"),
                        onTap: () {
                          Navigator.pushNamed(context, 'about');
                        },
                      ),
                    ],
                  ),
                ),

                body: Builder(
                  builder: (BuildContext context) => ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                        height: 80,
                        width: 500,
                        padding: const EdgeInsets.all(27),
                        margin: const EdgeInsets.fromLTRB(30, 25, 30, 9),
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: const Text("Battery Percentage"),
                      ),

                      Container(
                        height: 80,
                        width: 500,
                        padding: const EdgeInsets.all(27),
                        margin: const EdgeInsets.fromLTRB(30, 18, 30, 9),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 203, 147, 201),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: Offset(0.3, 0.60),
                              )
                            ]
                        ),
                        child: const SelectableText("State of Charge",
                          style: TextStyle(
                              color: Color.fromARGB(255, 116, 71, 138)),),
                      ),

                      Container(
                        height: 80,
                        width: 500,
                        padding: const EdgeInsets.all(27),
                        margin: const EdgeInsets.fromLTRB(30, 18, 30, 9),
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: const Text("Battery Health"),
                      ),

                      Container(
                        height: 80,
                        width: 500,

                        padding: const EdgeInsets.all(27),
                        margin: const EdgeInsets.fromLTRB(30, 18, 30, 9),
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(30))

                        ),
                        child: const Text("Status "),
                      ),

                      Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber[150],

                        ),
                      )
                    ],
                  ),
                )
            ),
      ),
      routes: {
        'settings': (context) => const Settings(),
        'home': (context) => MyApp(),
        'about' : (context) => const about_page(),
      },
    );
  }
}

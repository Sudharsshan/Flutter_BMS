//Importing screens for navigation through the app

import 'package:batterymanagementsystem/appLayouts/about_page.dart';
import 'package:batterymanagementsystem/appLayouts/settings.dart';
import 'package:batterymanagementsystem/progressWidgets/currentWidget.dart';
import 'package:batterymanagementsystem/progressWidgets/socWidget.dart';
import 'package:batterymanagementsystem/progressWidgets/sohWidget.dart';
import 'package:batterymanagementsystem/progressWidgets/voltageWidget.dart';
import 'package:batterymanagementsystem/theme.dart';

//Importing packages
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

//This var stores data from the api response received
String responseData = 'Loading...';

void main(){
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

  //Add a state for this widget and change the values of these variables accordingly to set the color for the gauge dynamically
  late Color myColorRedLight = const Color.fromARGB(255, 255, 97, 97);
  late Color myColorRedMedium = const Color.fromARGB(255, 255, 58, 58);
  late Color myColorRedHeavy = const Color.fromARGB(255, 255, 0, 0);

  late double field1, field2, field3, field5;
  late Timer _timer;
  bool _isRefreshing = false;

  //Initialises the shared_preferences for use into the app
  @override
  void initState(){
    super.initState();
    _loadTheme();
    
    //Get the data from the thingSpeak cloud to update it to the UI
    fetchData();

    _timer = Timer.periodic(Duration(minutes: 3), (timer) {
      fetchData();
    });
  }

  void dispose(){
    _timer.cancel();
    super.dispose();
  }



  Future<void> fetchData() async {

    try {
      final fetchLink = Uri.parse('https://api.thingspeak.com/channels/1943049/feeds.json?results=1');

      final response = await http.get(
        fetchLink,
      );
      print(("Data is fetched every 3 minutes"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> lastValueFromResponse = data['feeds'];
        setState(() {
          print("Initializing values");
          for(var data in lastValueFromResponse){
            field1 = double.parse(data['field1']);
            field2 = double.parse(data['field2']);
            field3 = double.parse(data['field3']);
            field5 = double.parse(data['field5']);
            print("Field1: ${field1}");
          }
        });
      } else {
        setState(() {
            print(("Error in fetching data"));
            field1 = field2 = field3 = field5 = 00;
        });
      }
    } catch (error) {
      setState(() {
        print("Error is: ${error}");
        field1 = field2 = field3 = field5 = 00;
      });
    }
  }

  Future<void> refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await fetchData();

    setState(() {
      _isRefreshing = false;
    });
  }

  //This method will fetch the Theme value from the shared_preferences
  void _loadTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = pref.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false, //To avoid the DEBUG banner
      theme: isDarkMode ? ThemeClass.darkTheme : ThemeClass.lightTheme,
      //App theme is set UNIVERSAL via this method
      home: Builder(
        builder: (BuildContext context) =>
            Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("BMS"),
                  backgroundColor: ThemeClass().lightPrimaryColor,
                  foregroundColor: ThemeClass().secondaryColor,
                  elevation: 30,
                  shadowColor: Colors.black,
                  actions: [
                    IconButton(
                        onPressed: _isRefreshing ? null : refreshData,
                        icon: Icon(Icons.refresh)
                    ),
                  ],
                ),

                drawer: Drawer(
                  backgroundColor: ThemeClass().lightPrimaryColor,
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
                          //Here this isn't required as this is the HOME screen
                          HapticFeedback.lightImpact();
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
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'about');
                        },
                      ),
                    ],
                  ),
                ),

                body: LiquidPullToRefresh(
                    springAnimationDurationInMilliseconds: 300,
                    onRefresh: fetchData,
                    color: ThemeClass().lightPrimaryColor,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        //Implemented the radial gauge
                        SOC(percent: field2),

                        SOH(percent: field5),

                        VOLTAGE(percent: field3),

                        CURRENT(percent: field1),
                      ],
                    ),
                  ),
                )
            ),
      
      routes: {
        'settings': (context) => const Settings(),
        'home': (context) => MyApp(),
        'about' : (context) => const about_page(),
      },
    );
  }
}



//This method calculates the percent of the gauge (linear and circular) to be filled
//with the given parameters
double percentValue (double max, double currentValue){
  print((currentValue/max)); //for  debug purpose
  return (currentValue/max);
}

//This method determines the color of widget according to the values provided
/*
<= 30% : RED
> 30% && <50% : ORANGE
> 50% && <80% : YELLOW
> 80% : GREEN
 */
Color widgetColor(double max, double currentValue){
  double multiplyFactor = currentValue/max;
  Color color;

  if(currentValue <= (0.3*max))
    {
      //  <30% of max value
      //Color is RED
      print("RED");
      color = const Color.fromARGB(200, 255, 0, 0);
    }
  else if( currentValue > (0.3*max) && currentValue <= (0.5*max)){
    // > 30% && < 50%
    // Color is Orange
    print("ORANGE");
    color = const Color.fromARGB(200, 255, 150, 0);
  }
  else if( currentValue > (0.5*max) && currentValue <= (0.8*max)){
    // >50% && < 80%
    // Color is YELLOW
    print("YELLOW");
    color = const Color.fromARGB(200, 255, 250, 0);
  }
  else {
    // Color is GREEN
    print("GREEN");
    color = const Color.fromARGB(200, 0, 255, 0);
  }
  return color;

}



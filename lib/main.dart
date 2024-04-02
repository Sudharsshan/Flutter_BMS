//Importing screens for navigation through the app

import 'package:batterymanagementsystem/appLayouts/about_page.dart';
import 'package:batterymanagementsystem/appLayouts/mainPage.dart';
import 'package:batterymanagementsystem/appLayouts/settings.dart';
import 'package:batterymanagementsystem/progressWidgets/currentWidget.dart';
import 'package:batterymanagementsystem/progressWidgets/socWidget.dart';
import 'package:batterymanagementsystem/progressWidgets/sohWidget.dart';
import 'package:batterymanagementsystem/progressWidgets/voltageWidget.dart';
import 'package:batterymanagementsystem/theme.dart';
import 'package:batterymanagementsystem/networkStuff/model.dart';

//Importing packages
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
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


  late double field1 = 50, field2 = 0, field3 = 0, field5 = 0;
  bool _isRefreshing = true, calldata = false;
  late Map<String, double> passOnData;

  //Initialises the shared_preferences for use into the app
  @override
  void initState(){
    super.initState();
    _loadTheme();
    
    //Get the data from the thingSpeak cloud to update it to the UI
    print("Initial background task updating values");
    updateData();

    Timer.periodic(const Duration(minutes: 3), (timer) {
      print("Periodic background task updating values");
      updateData();
    });
  }

  //Update the data after the API call
  void updateData() async{
    print("(MAIN) called by refreshData()? $calldata?");
    passOnData = await networkHandler().fetchData();
    field1 = passOnData['Current']!;
    field2 = passOnData['SOC']!;
    field3 = passOnData['Voltage']!;
    field5 = passOnData['SOH']!;
    print("(MAIN) SOH: ${passOnData['SOH']}");
    setState(() {
      _isRefreshing = false;
      calldata = false;
    });
  }

  void dispose(){
    super.dispose();
  }

  Future<void> refreshData() async {
    print("Initialized forceful update of UI widgets");
    updateData();
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
    print('(MAIN)(BUILD) SOH: $field5');
    return MaterialApp(
      debugShowCheckedModeBanner: false, //To avoid the DEBUG banner

      home: Builder(
        builder: (BuildContext context) =>
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("BMS"),
                backgroundColor: Color.fromARGB(255, 0, 59, 46),
                foregroundColor: Color.fromARGB(255, 109, 151, 115),
                elevation: 30,
                shadowColor: Colors.black,
                actions: [
                  IconButton(
                      onPressed: updateData,
                      icon: Icon(Icons.refresh),
                  ),
                ],
              ),

              drawer: Drawer(
                backgroundColor: Color.fromARGB(255, 109, 151, 115),
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

              body: _isRefreshing? Center(child: CircularProgressIndicator(color: ThemeClass().lightPrimaryColor,),) : mainPage(field1, field2, field3, field5),
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
//Importing screens for navigation through the app
import 'package:batterymanagementsystem/about_page.dart';
import 'package:batterymanagementsystem/settings.dart';

//Importing packages
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
                          //Here this isn't required as this is the HOME screen
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
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
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

                      //Implemented the radial gauge
                      SizedBox(
                        height: 300,
                        width: 200,
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: SfRadialGauge(
                                    axes: <RadialAxis>[
                                      RadialAxis(
                                        minimum: 0,
                                        maximum: 100,
                                        showLabels: false,
                                        showTicks: false,
                                        axisLineStyle: AxisLineStyle(
                                          thickness: 0.1,
                                          color: Colors.grey[700],
                                          thicknessUnit: GaugeSizeUnit.factor,
                                        ),
                                        pointers: <GaugePointer>[
                                          //This method draws the radial gauge with the specified value
                                          RangePointer(
                                            value: 55,
                                            width: 0.1,
                                            sizeUnit: GaugeSizeUnit.factor,
                                            gradient: SweepGradient(
                                              colors: <Color>[
                                                myColorRedLight,
                                                myColorRedMedium,
                                                myColorRedHeavy,
                                              ],
                                              stops: const <double>[0.0, 0.6, 1.0],
                                            ),
                                            enableAnimation: true,
                                          ),
                                        ],
                                        annotations: const <GaugeAnnotation>[
                                          GaugeAnnotation(
                                            widget: Text(
                                              'State of Charge',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink,
                                              ),
                                            ),
                                            positionFactor: 0.2,
                                            angle: 90,
                                          ),
                                          GaugeAnnotation(
                                            widget: Text(
                                              '55%',
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink,
                                              ),
                                            ),
                                            positionFactor: 0.5,
                                            angle: 90,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      Container(
                        height: 80,
                        width: 500,
                        padding: const EdgeInsets.all(27),
                        margin: const EdgeInsets.fromLTRB(30, 25, 30, 9),
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: SOH(percent: 0.54,),
                      ),

                      Container(
                        height: 80,
                        width: 500,
                        padding: const EdgeInsets.all(27),
                        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                        child: VOLTAGE(percent: 0.7,),
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
                        child: CURRENT(percent: 0.3),
                      ),
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

class BatteryInfoContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const BatteryInfoContainer({super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.pink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ],
    );
  }
}
late double State_Of_Health;


class SOH extends StatefulWidget {
late double percent;
  SOH( {
    required this.percent,
});

  @override
  _SOHState createState() => _SOHState(percent);
}

class _SOHState extends State<SOH> {
  String finalD = '';

  _SOHState(double percent){
    State_Of_Health = percent;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    //  Here you get your percentage and the assign it to the percentage

    finalD = (State_Of_Health*100).toString(); // here you asign to the String
// or convert it to int as :finalD =(percentage * 100).toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: LinearPercentIndicator(
          width: MediaQuery.of(context).size.width -120,
          animation: true,
          lineHeight: 40.0,
          animationDuration: 2500,
          percent: State_Of_Health,
          center: Text('Voltage: $finalD'),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Colors.yellow,

        ),
      ),
    );
  }
}


late double VoltageData;
class VOLTAGE extends StatefulWidget {
  late double percent;
  VOLTAGE( {
    required this.percent,
  });

  @override
  _VOLTAGEState createState() => _VOLTAGEState(percent);
}

class _VOLTAGEState extends State<VOLTAGE> {
  String finalD = '';

  _VOLTAGEState(double percent){
    VoltageData = percent;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    //  Here you get your percentage and the assign it to the percentage

    finalD = (VoltageData*100).toString(); // here you asign to the String
// or convert it to int as :finalD =(percentage * 100).toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: LinearPercentIndicator(
          width: MediaQuery.of(context).size.width -120,
          animation: true,
          lineHeight: 40.0,
          animationDuration: 2500,
          percent: VoltageData,
          center: Text('Voltage: $finalD'),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Colors.yellow,

        ),
      ),
    );
  }
}


late double CurrentData;
class CURRENT extends StatefulWidget {
  late double percent;
  CURRENT( {
    required this.percent,
  });

  @override
  _CURRENTState createState() => _CURRENTState(percent);
}

class _CURRENTState extends State<CURRENT> {
  String finalD = '';

  _CURRENTState(double percent){
    CurrentData = percent;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    //  Here you get your percentage and the assign it to the percentage

    finalD = (CurrentData*100).toString(); // here you asign to the String
// or convert it to int as :finalD =(percentage * 100).toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: LinearPercentIndicator(
          width: MediaQuery.of(context).size.width -120,
          animation: true,
          lineHeight: 40.0,
          animationDuration: 2500,
          percent: CurrentData,
          center: Text('Current: $finalD'),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Colors.yellow,

        ),
      ),
    );
  }
}



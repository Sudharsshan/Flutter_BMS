//Importing screens for navigation through the app

import 'package:batterymanagementsystem/about_page.dart';
import 'package:batterymanagementsystem/settings.dart';
import 'package:batterymanagementsystem/theme.dart';

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

                body: Builder(
                  builder: (BuildContext context) => LiquidPullToRefresh(
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


late double State_of_Charge;
class SOC extends StatefulWidget{
  late double percent;
  SOC({super.key,
  required this.percent});

  @override
  _SOCState createState() => _SOCState(percent);
}

class _SOCState extends State<SOC>{
  String finalD = '';

  _SOCState(double percent){
    State_of_Charge = percent;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Building radial gauge");
    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    //  Here you get your percentage and the assign it to the percentage

    finalD = (State_of_Charge).toString(); // here you assign to the String
    // or convert it to int as :finalD =(percentage).toInt().toString();
  }


  @override
  Widget build(BuildContext context){
    return SizedBox(
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
                          value: State_of_Charge,
                          width: 0.1,
                          sizeUnit: GaugeSizeUnit.factor,
                          color: widgetColor(100, State_of_Charge),
                          enableAnimation: true,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        const GaugeAnnotation(
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
                            '$finalD %',
                            style: const TextStyle(
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
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}


late double State_Of_Health;
class SOH extends StatefulWidget {
late double percent;
  SOH( {super.key,
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
    print("building State_Of_Health");
    
    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    //  Here you get your percentage and the assign it to the percentage

    finalD = (State_Of_Health).toString(); // here you assign to the String
// or convert it to int as :finalD =(percentage * 100).toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width,
        animation: true,
        lineHeight: 80.0,
        barRadius: const Radius.elliptical(10, 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        percent: percentValue(100, State_Of_Health),
        center: Text('State of Health: ${finalD}%', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), ), //Overriding theme colors to prevent visibility issue
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: widgetColor(100, State_Of_Health), //CHANGE THIS AS PER VALUE
      ),
    );
  }
}


late double VoltageData;
class VOLTAGE extends StatefulWidget {
  late double percent;
  VOLTAGE( {super.key,
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
    print("building Voltage");
    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    //  Here you get your percentage and the assign it to the percentage

    finalD = (VoltageData).toString(); // here you asign to the String
// or convert it to int as :finalD =(percentage * 100).toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width,
        animation: true,
        lineHeight: 80.0,
        percent: percentValue(48, VoltageData),
        center: Text('Voltage: ${finalD}V', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),), //Overriding theme colors to prevent visibility issue
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: widgetColor(48, VoltageData), //CHANGE THIS AS PER THE VALUE
        barRadius: const Radius.elliptical(10, 20),
    
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
    print("building Current");
    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    //  Here you get your percentage and the assign it to the percentage

    finalD = (CurrentData).toString(); // here you asign to the String
// or convert it to int as :finalD =(percentage * 100).toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width,
        animation: true,
        lineHeight: 80.0,
        barRadius: const Radius.elliptical(10, 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        percent: percentValue(30, CurrentData),
        center: Text('Current: ${finalD}A', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),), //Overriding theme colors to prevent visibility issue
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: widgetColor(30, CurrentData),
      ),
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



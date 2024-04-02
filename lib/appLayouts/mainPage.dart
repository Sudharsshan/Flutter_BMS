import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../progressWidgets/currentWidget.dart';
import '../progressWidgets/socWidget.dart';
import '../progressWidgets/sohWidget.dart';
import '../progressWidgets/voltageWidget.dart';

//ignore: must_be_immutable
class mainPage extends StatefulWidget{
  late double field1, field2, field3, field5;
  mainPage(double field1, double field2, double field3, double field5){
    this.field1 = field1;
    this.field2 = field2;
    this.field3 = field3;
    this.field5 = field5;
  }

  @override
  State<mainPage> createState() => mainPageState(field1, field2, field3, field5);
}

class mainPageState extends State<mainPage>{
  late double field1, field2, field3, field5;
  bool isDarkMode = false;

  mainPageState(double field1, double field2, double field3, double field5){
    this.field1 = field1;
    this.field2 = field2;
    this.field3 = field3;
    this.field5 = field5;
    print("CONSTRUCTUR CALL: $field1");
  }

  @override
  void initState(){
    super.initState();
    print('(MAINPAGE-INITSTATE) SOH = $field5');
    loadTheme();
  }

  void loadTheme() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isDarkMode = preferences.getBool('isDarkMode') ?? false;
    setState(() {
      //Just do nothing.
    });
  }

  @override
  Widget build(BuildContext context) {
    print('(MAINPAGE) Value of SOH: $field5');
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(isDarkMode? "assets/images/DARK.png": "assets/images/LIGHT.png"),
              repeat: ImageRepeat.repeat
          )
      ),
      child:  ListView(
        scrollDirection: Axis.vertical,
        children: [
          //Implemented the radial gauge
          SOC(percent: field2,),

          SOH(percent: field5),

          VOLTAGE(percent: field3),

          CURRENT(percent: field1),
        ],
      ),
    );
  }
}
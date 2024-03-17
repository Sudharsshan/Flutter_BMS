import 'package:batterymanagementsystem/main.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

/*
  This class builds a linear progress bar widget to show the Voltage data parameter of the battery.
 */

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


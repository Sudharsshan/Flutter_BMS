import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../main.dart';

/*
  This class builds a linear progress bar widget to show the State of Health parameter of the battery.
 */

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

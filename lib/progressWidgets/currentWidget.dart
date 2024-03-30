import 'package:flutter/material.dart';
import 'package:batterymanagementsystem/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

late double CurrentData;
//ignore: must_be_immutable
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

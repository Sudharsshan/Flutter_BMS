import 'package:batterymanagementsystem/theme.dart';
import 'package:flutter/material.dart';
import 'package:batterymanagementsystem/percentindicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(child: SampleApp()),
      ),
    );
  }
}

class SampleApp extends StatefulWidget {
  SampleApp({super.key});

  @override
  _SampleAppState createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp> {
  String finalD = '';
  late double percentage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    percentage = 10 /100; //  Here you get your percentage and the assign it to the percentage

    finalD = (percentage*100).toString(); // here you asign to the String
// or convert it to int as :finalD =(percentage * 100).toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: LinearPercentIndicator(
          width: MediaQuery.of(context).size.width - 50,
          animation: true,
          lineHeight: 25.0,
          animationDuration: 2500,
          percent: percentage,
          center: Text('$finalD'),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Colors.yellow,
        ),
      ),
    );
  }
}

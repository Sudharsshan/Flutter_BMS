import 'package:batterymanagementsystem/theme.dart';
import 'package:flutter/material.dart';
import 'package:batterymanagementsystem/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:ui' as ui show ImageFilter;

/*
  This class Builds the Radial Widget showing the state of Charge of the  battery.
 */

class BatteryInfoContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  BatteryInfoContainer({super.key,
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
late bool isDarkMode = false, isRefreshing = true;
//ignore: must_be_immutable
class SOC extends StatefulWidget{
  late double percent;

  SOC({super.key,
    required this.percent,});

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
    super.initState();
    print("Building radial gauge");
    //This is you value 10 where you divide by 100 then you get the value
    // between 0 -1 which is expected by the linerprogressindicator
    //  Here you get your percentage and the assign it to the percentage

    finalD = (State_of_Charge).toString(); // here you assign to the String
    // or convert it to int as :finalD =(percentage).toInt().toString();

    loadTheme();
  }

  void loadTheme() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isDarkMode = preferences.getBool('isDarkMode') ?? false;
    setState(() {
      isRefreshing = false;
    });
  }
  @override
  Widget build(BuildContext context){
    print("Value of isDarkMode: $isDarkMode");
    return SizedBox(
      height: 300,
      width: 200,
      child: isRefreshing? Center(child: CircularProgressIndicator(color: ThemeClass().lightPrimaryColor,),) : Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                      sigmaX: 7,
                      sigmaY: 7,
                      tileMode: TileMode.clamp
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                            color: Color.fromARGB(200, 80, 80, 80),
                            thicknessUnit: GaugeSizeUnit.factor,
                            cornerStyle: CornerStyle.bothCurve,
                          ),
                          pointers: <GaugePointer>[
                            //This method draws the radial gauge with the specified value
                            RangePointer(
                              value: State_of_Charge,
                              width: 0.1,
                              sizeUnit: GaugeSizeUnit.factor,
                              color: widgetColor(100, State_of_Charge),
                              enableAnimation: true,
                              cornerStyle: CornerStyle.bothCurve,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text('State of Charge',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              positionFactor: 0.2,
                              angle: 90,
                            ),
                            GaugeAnnotation(
                              widget: Text(
                                '$finalD %',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 0, 0, 0),
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
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

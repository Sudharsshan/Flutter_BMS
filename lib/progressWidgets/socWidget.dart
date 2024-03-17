import 'package:flutter/material.dart';
import 'package:batterymanagementsystem/main.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

/*
  This class Builds the Radial Widget showing the state of Charge of the  battery.
 */

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

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() => runApp(ChartApp());

class ChartApp extends StatelessWidget {

  //Add a state for this widget and change the values of these variables accordingly to set the color for the gauge dynamically
  late Color myColorRedLight = const Color.fromARGB(255, 255, 97, 97);
  late Color myColorRedMedium = const Color.fromARGB(255, 255, 58, 58);
  late Color myColorRedHeavy = const Color.fromARGB(255, 255, 0, 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Kurama'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('BMS'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.home, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Home'),
                  ],
                ),
                onTap: () {
                  // Handle home navigation
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
                onTap: () {
                  // Handle settings navigation
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.info, color: Colors.green),
                    SizedBox(width: 8),
                    Text('About'),
                  ],
                ),
                onTap: () {
                  // Handle about navigation
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: Color(0xFF2C3E50),
          child: Column(
            children: [
              SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: Container(
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
                                stops: <double>[0.0, 0.6, 1.0],
                              ),
                              enableAnimation: true,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                'Vehicle Battery',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                                  color: Colors.white,
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
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BatteryInfoContainer(
                      icon: Icons.battery_charging_full,
                      label: 'Battery Health',
                      value: 'Good',
                      iconColor: Colors.green,
                    ),
                    BatteryInfoContainer(
                      icon: Icons.battery_full,
                      label: 'Battery Percentage',
                      value: '55%',
                      iconColor: Colors.yellow,
                    ),
                    BatteryInfoContainer(
                      icon: Icons.power,
                      label: 'Battery Status',
                      value: 'Charging',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class BatteryInfoContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const BatteryInfoContainer({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({Key? key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Change Theme:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Switch(
                      value: _themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        if (value) {
                          changeTheme(ThemeMode.dark);
                        } else {
                          changeTheme(ThemeMode.light);
                        }
                      },
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

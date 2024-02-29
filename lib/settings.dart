import 'package:flutter/material.dart';

void main() {
  runApp(Settings());
}

class Settings extends StatefulWidget {
  const Settings({Key? key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeMode _themeMode = ThemeMode.system;
  IconData _themeIcon = Icons.light_mode;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      _themeIcon = themeMode == ThemeMode.dark ? Icons.nightlight_round : Icons.wb_sunny;
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
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings"),
          backgroundColor: const Color.fromARGB(255, 201, 151, 207),
          elevation: 30,
          foregroundColor: const Color.fromARGB(255, 116, 71, 138),
          shadowColor: Colors.black,
        ),
        drawer: Drawer(
          backgroundColor: Colors.deepPurple[200],
          child: Column(
            children: [
              const DrawerHeader(
                child: Column(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 80,
                      color: Colors.black45,
                    ),
                    Text("BMS"),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("H O M E"),
                onTap: () {
                  Navigator.pushNamed(context, 'home');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("S E T T I N G S"),
                onTap: () {
                  Navigator.pushNamed(context, 'settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text("A B O U T"),
                onTap: () {
                  Navigator.pushNamed(context, 'about');
                },
              ),
            ],
          ),
        ),
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
                    Icon(_themeIcon),
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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Settings());
}

class Settings extends StatefulWidget {
  const Settings({Key? key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  IconData _themeIcon = Icons.light_mode;

  bool isDarkMode = false; //Initially the app is in light mode

  @override
  void initState(){
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = pref.getBool('isDarkMode') ?? false;
      _themeIcon = isDarkMode ? Icons.nightlight_round : Icons.wb_sunny;
    });
  }

  void _saveTheme(bool value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
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
                    const Text(
                      'Change Theme:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    Switch(
                      value: isDarkMode,
                      onChanged: (newvalue) {
                        setState(() {
                          isDarkMode = newvalue;
                          _themeIcon = newvalue ? Icons.nightlight_round : Icons.wb_sunny;
                        });
                        _saveTheme(newvalue);//Save the newly selected theme
                        print('Theme has been changed: $newvalue');
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
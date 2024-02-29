import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class about_page extends StatefulWidget {
  const about_page({super.key});

  @override
  State<about_page> createState() => _about_page();
}

class _about_page extends State<about_page>{
  /*
    This page contains the basic info of the app and the project.
   */
  bool isDarkMode = false; //Initially it is in dark mode

  @override
  void initState(){
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = pref.getBool('isDarkMode') ?? false;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle:true,
          title: const Text("About"),
          backgroundColor: const Color.fromARGB(255, 203, 147, 201),
          elevation: 30,
          foregroundColor: const Color.fromARGB(255, 116, 71, 138),
          shadowColor: Colors.black,
        ),

        drawer: Drawer(
          backgroundColor: Colors.deepPurple[200],
          child: Column(
            children: [
              const DrawerHeader(child: Column(
                children: [
                  Icon(Icons.settings, size: 80,color: Colors.black45,),
                  Text("BMS"),
                ],
              )),

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

        body: const Center(
          child: Text("About page"),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

/*
  This page contains the settings of the app as follows:
  - Theme of the app
  - Push notifications (implement in future)
 */
class Settings extends StatelessWidget{
   const Settings ({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle:true,
          title: const Text("Settings"),
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

        body: Column(
                  children: [
                  Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.symmetric(),
                    child: Text("Theme",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(1.0)),

                    ),
                  ),
                    Container(
                      height: 200,
                      width: 200,
                      child: Text("Theme"),
                    )
                ]
        ),
      ),
    );
  }
}
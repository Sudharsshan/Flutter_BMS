import 'package:batterymanagementsystem/about_page.dart';
import 'package:batterymanagementsystem/settings.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  Future<String> batteryPercentage() async{
    Future<String> level = "0" as Future<String>;
    return level;
  }

  static const int a = 10;
  //Rebuild the color of the app.
  //For the time being, only the structure of the app will be made which can be edited later after discussion with the team.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) =>
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("BMS"),
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
                        Icon(Icons.settings, size: 80, color: Colors.black45,),
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

              body: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    height: 80,
                    width: 500,
                    padding: const EdgeInsets.all(27),
                    margin: const EdgeInsets.fromLTRB(30, 25, 30, 9),
                    decoration: const BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: const Text("Battery Percentage"),
                  ),

                  Container(
                    height: 80,
                    width: 500,
                    padding: const EdgeInsets.all(27),
                    margin: const EdgeInsets.fromLTRB(30, 18, 30, 9),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 203, 147, 201),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(0.3, 0.60),
                          )
                        ]
                    ),
                    child: const SelectableText("State of Charge",
                      style: TextStyle(
                          color: Color.fromARGB(255, 116, 71, 138)),),
                  ),

                  Container(
                    height: 80,
                    width: 500,
                    padding: const EdgeInsets.all(27),
                    margin: const EdgeInsets.fromLTRB(30, 18, 30, 9),
                    decoration: const BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: const Text("Battery Health"),
                  ),

                  Container(
                    height: 80,
                    width: 500,

                    padding: const EdgeInsets.all(27),
                    margin: const EdgeInsets.fromLTRB(30, 18, 30, 9),
                    decoration: const BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(30))

                    ),
                    child: const Text("and many more"),
                  ),

                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber[150],

                    ),
                  )
                ],
              ),
            ),
      ),
      routes: {
        'settings': (context) => const Settings(),
        'home': (context) => const MyApp(),
        'about' : (context) => const about_page(),
      },
    );
  }
}

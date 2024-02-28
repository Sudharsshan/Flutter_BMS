import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

class model extends StatelessWidget {
  String altitudeData = 'Loading...';
  
  Future<void> fetchData() async {
    try {
      final fetchLink = Uri.parse('https://io.adafruit.com/api/v2/SudharsshanSY/feeds/altitude');
      const apiKey = 'aio_fOIT54TDT5jDFxcL9HuByjJusqha'; // Replace with your API key

      final response = await http.get(
        fetchLink,
        headers: {
          'X-AIO-Key': apiKey, // Include API key in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lastValueFromResponse = data['last_value'];
          altitudeData = lastValueFromResponse.toString();
      } else {
          altitudeData = 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (error) {
        altitudeData = 'Error: $error';
    }
  }
  
String responseData = 'Loading...';

//This is a background task executor which will execute a background task as long as you want
void callBackDispatcher(){
  Workmanager().executeTask((taskName, link) async {
    //logic is here
    try {
      final fetchLink = Uri.parse(link as String);
      const apiKey = 'aio_fOIT54TDT5jDFxcL9HuByjJusqha'; // Replace with your API key

      final response = await http.get(
        fetchLink,
        headers: {
          'X-AIO-Key': apiKey, // Include API key in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lastValueFromResponse = data['last_value'];
          responseData = lastValueFromResponse.toString();
      } else {
          responseData = 'Failed to fetch data: ${response.statusCode}';
      }

    } catch (error) {
        responseData = 'Error: $error';
    }
    return Future.value(true);
  });
}

//This method will create a scheduled task to be executed in the background at particular intervals as specified
void scheduleTask(){
  Workmanager().registerPeriodicTask(
      'myTask',
      'simpleTask',
      frequency: const Duration(minutes: 2),
      inputData: <String, dynamic>{'key': 'value'});
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callBackDispatcher);
  
  runApp(MaterialApp(
    home: model(),
  ));
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

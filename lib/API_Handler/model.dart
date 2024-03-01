import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class AltitudeWidget extends StatefulWidget {
  const AltitudeWidget({super.key});

  @override
  _AltitudeWidgetState createState() => _AltitudeWidgetState();
}

class _AltitudeWidgetState extends State<AltitudeWidget> {
  String altitudeData = 'Loading...';
  late Timer _timer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Fetch data initially
    fetchData();

    //Demo toast message
    Fluttertoast.showToast(msg: 'Data is refreshed every 3 seconds',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.8),
        textColor: Colors.white);


    // Schedule fetching data every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final fetchLink = Uri.parse('https://io.adafruit.com/api/v2/SudharsshanSY/feeds/altitude');
      final apiKey = 'aio_fOIT54TDT5jDFxcL9HuByjJusqha'; // Replace with your API key

      final response = await http.get(
        fetchLink,
        headers: {
          'X-AIO-Key': apiKey, // Include API key in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lastValueFromResponse = data['last_value'];

        setState(() {
          altitudeData = lastValueFromResponse.toString();
        });
      } else {
        setState(() {
          altitudeData = 'Failed to fetch data: ${response.statusCode}';
        });
      }

    } catch (error) {
      setState(() {
        altitudeData = 'Error: $error';
      });
    }
  }

  Future<void> refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await fetchData();

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Altitude Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : refreshData,
          ),
        ],
      ),
      body: Center(
        child: _isRefreshing
            ? CircularProgressIndicator()
            : Text(altitudeData),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AltitudeWidget(),
  ));
}

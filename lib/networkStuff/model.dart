import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class networkHandler{
  late double field1 = 0 , field2 = 0, field3 = 0, field5 = 0;

  Map<String, double> gatheredData = {
    'Current' : 0.0,
    'SOC' : 0.0,
    'Voltage' : 0.0,
    'SOH' : 0.0,
  };

  Future<Map<String, double>> fetchData() async {
    print("Initialized background data fetch");
    try {
      final fetchLink = Uri.parse('https://api.thingspeak.com/channels/1943049/feeds.json?results=1');

      final response = await http.get(
        fetchLink,
      );
      print(("Data is fetched every 3 minutes"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> lastValueFromResponse = data['feeds'];
        print("Fetching values");
        for(var data in lastValueFromResponse){
        gatheredData['Current'] = field1 = double.parse(data['field1']);
        gatheredData['SOC'] = field2 = double.parse(data['field2']);
        gatheredData['Voltage'] = field3 = double.parse(data['field3']);
        gatheredData['SOH'] = field5 = double.parse(data['field5']);
        print("model.dart (DEBUG) SOH: ${gatheredData['SOH']}");
        }
      } else {
          print(("Error in fetching data"));
          gatheredData['Current'] = gatheredData['SOC'] = gatheredData['Voltage'] = gatheredData['SOH'] = 0;
      }
    } catch (error) {
        print("Error is: ${error}");
        gatheredData['Current'] = gatheredData['SOC'] = gatheredData['Voltage'] = gatheredData['SOH'] = 0;
    }

    return gatheredData;
  }
}
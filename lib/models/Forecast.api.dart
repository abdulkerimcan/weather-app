import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/Forecast.dart';

class ForecastApi {
  Future<Forecast?> getCurrentForecast(String? location) async {
    var uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=yourapikey&units=metric");
    var response = await http.get(uri);
    var body = jsonDecode(response.body);


    return Forecast.fromJson(body);
  }
}

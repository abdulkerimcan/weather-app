class Forecast {
  final String city;
  final double temp;
  final double feels_like;
  final String description;
  final int humidity;
  final double wind;
  Forecast({
    required this.city,
    required this.temp,
    required this.feels_like,
    required this.description,
    required this.humidity,
    required this.wind

  });

  factory Forecast.fromJson(Map<String,dynamic> json) {
    return Forecast(city: json["name"] as String, temp: json["main"]["temp"] as double,feels_like: json["main"]["feels_like"] as double, description: json["weather"][0]["description"] as String, humidity: json["main"]["humidity"] as int,wind: json["wind"]["speed"] as double);
  }
}

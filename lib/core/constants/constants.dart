import 'package:weather_tdd_clean/config/keys/keys.dart';

class Urls {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static String currentWeatherByName(String city) =>
      '$baseUrl/weather?q=$city&appid=$apiKey&units=metric';
  static String weatherIcon(String iconCode) =>
      'http://openweathermap.org/img/wn/$iconCode@2x.png';
}

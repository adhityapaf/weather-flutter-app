import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_tdd_clean/data/models/weather_model.dart';
import 'package:weather_tdd_clean/domain/entities/weather.dart';

import '../../helpers/json_reader.dart';

void main() {
  const testWeatherModel = WeatherModel(
    cityName: 'Denpasar',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 31.81,
    pressure: 1011,
    humidity: 70,
  );
  test('should be a subclass of weather entity', () async {
    // assert
    expect(testWeatherModel, isA<WeatherEntity>());
  });

  test('should return a valid model from json', () async {
    // arrange
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('helpers/dummy_data/dummy_weather_response.json'),
    );
    // act
    final result = WeatherModel.fromJson(jsonMap);

    // assert (expect)
    expect(result, equals(testWeatherModel));
  });

  test('should return a json map containing proper', () async {
    // act
    final result = testWeatherModel.toJson();

    // assert
    final expectedJsonMap = {
      'weather': [
        {
          'main': 'Clouds',
          'description': 'few clouds',
          'icon': '02d',
        },
      ],
      'main': {
        'temp': 31.81,
        'pressure': 1011,
        'humidity': 70,
      },
      'name': 'Denpasar',
    };

    expect(result, equals(expectedJsonMap));
  });
}

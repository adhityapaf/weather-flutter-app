import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_tdd_clean/domain/entities/weather.dart';
import 'package:weather_tdd_clean/domain/usecases/get_current_weather.dart';

import '../../helpers/test_helpers.mocks.dart';

void main() {
  late GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    getCurrentWeatherUseCase = GetCurrentWeatherUseCase(mockWeatherRepository);
  });

  const testWeatherDetail = WeatherEntity(
    cityName: 'Denpasar',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 29.84,
    pressure: 1011,
    humidity: 70,
  );

  const testCityName = 'Denpasar';

  test('should get current weather detail from the repository', () async {
    // arrange
    when(mockWeatherRepository.getCurrentWeather(testCityName))
        .thenAnswer((_) async => const Right(testWeatherDetail));
    // act
    final result = await getCurrentWeatherUseCase.execute(testCityName);

    // assert
    expect(result, const Right(testWeatherDetail));
  });
}

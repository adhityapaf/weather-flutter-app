import 'package:dartz/dartz.dart';
import 'package:weather_tdd_clean/core/error/failure.dart';
import 'package:weather_tdd_clean/domain/entities/weather.dart';
import 'package:weather_tdd_clean/domain/repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository weatherRepository;
  const GetCurrentWeatherUseCase(this.weatherRepository);
  Future<Either<Failure, WeatherEntity>> execute(String cityName) {
    return weatherRepository.getCurrentWeather(cityName);
  }
}

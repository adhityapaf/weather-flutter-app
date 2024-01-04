import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weather_tdd_clean/core/error/exception.dart';
import 'package:weather_tdd_clean/core/error/failure.dart';
import 'package:weather_tdd_clean/data/data_sources/remote_data_source.dart';
import 'package:weather_tdd_clean/domain/entities/weather.dart';
import 'package:weather_tdd_clean/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(
      String cityName) async {
    try {
      final result = await weatherRemoteDataSource.getCurrentWeather(cityName);
      return Right(result.toEntity());
    } catch (e) {
      log('[Error]: $e');
      if (e is ServerException) {
        log('[ServerError]: (${e.statusCode}) ${e.body}');
        return const Left(ServerFailure('An error has occurred'));
      } else if (e is SocketException) {
        return const Left(
            ConnectionFailure('Failed to connect to the network'));
      } else {
        return const Left(UnknownFailure('Unknown Error'));
      }
    }
  }
}

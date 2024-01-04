import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_tdd_clean/core/error/failure.dart';
import 'package:weather_tdd_clean/domain/entities/weather.dart';
import 'package:weather_tdd_clean/presentation/bloc/weather_bloc.dart';
import 'package:weather_tdd_clean/presentation/bloc/weather_event.dart';
import 'package:weather_tdd_clean/presentation/bloc/weather_state.dart';

import '../../helpers/test_helpers.mocks.dart';

void main() {
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    weatherBloc = WeatherBloc(mockGetCurrentWeatherUseCase);
  });

  const testWeather = WeatherEntity(
    cityName: 'Denpasar',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 31.81,
    pressure: 1011,
    humidity: 70,
  );

  const testCityName = 'Denpasar';

  test('initial state should be empty', () {
    expect(weatherBloc.state, WeatherEmpty());
  });

  blocTest<WeatherBloc, WeatherState>(
    'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName))
          .thenAnswer((_) async => const Right(testWeather));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      const WeatherLoaded(testWeather),
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'should emit [WeatherLoading, WeatherLoadFailure] when get data is unsuccessful',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName))
          .thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      const WeatherLoadFailure('Server failure'),
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'should emit [WeatherLoading, WeatherEmpty] when query is empty',
    build: () {
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      WeatherEmpty(),
    ],
  );
}

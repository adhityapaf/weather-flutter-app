import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_tdd_clean/domain/entities/weather.dart';
import 'package:weather_tdd_clean/presentation/bloc/weather_bloc.dart';
import 'package:weather_tdd_clean/presentation/bloc/weather_event.dart';
import 'package:weather_tdd_clean/presentation/bloc/weather_state.dart';
import 'package:weather_tdd_clean/presentation/pages/weather_page.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>(
      create: (context) => mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const testWeather = WeatherEntity(
    cityName: 'Denpasar',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 31.81,
    pressure: 1011,
    humidity: 70,
  );

  const failureText = 'Error to load data';

  testWidgets('text field should trigger state to change from empty to loading',
      (widgetTester) async {
    // arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());

    // act
    await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));
    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await widgetTester.enterText(textField, 'Denpasar');
    await widgetTester.pump();
    // assert
    expect(find.text('Denpasar'), findsOneWidget);
  });

  testWidgets('should show progress indicator when state is loading',
      (widgetTester) async {
    // arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());

    // act
    await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'should show widget containing weather data when state is weather loaded',
      (widgetTester) async {
    // arrange
    when(() => mockWeatherBloc.state)
        .thenReturn(const WeatherLoaded(testWeather));

    // act
    await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));
    await widgetTester.pumpAndSettle();

    // assert
    expect(find.byKey(const Key('weather_data')), findsOneWidget);
  });

  testWidgets('should show error text when state is weather load failure',
      (widgetTester) async {
    // arrange
    when(() => mockWeatherBloc.state)
        .thenReturn(const WeatherLoadFailure(failureText));

    // act
    await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));

    // assert
    expect(find.text(failureText), findsOneWidget);
  });
}

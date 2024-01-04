import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class OnCityChanged extends WeatherEvent {
  final String cityName;

  const OnCityChanged(this.cityName);

  @override
  List<Object?> get props => [cityName];
}

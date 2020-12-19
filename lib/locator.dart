import 'package:get_it/get_it.dart';
import 'package:weather_forecast/data/weather_api_client.dart';
import 'package:weather_forecast/data/weather_repository.dart';
import 'package:weather_forecast/viewmodels/weather_view_model.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => WeatherRepository());
  locator.registerLazySingleton(() => WeatherApiClient());
  locator.registerFactory(
      () => WeatherViewModel()); //her istekte tekrar üretilecek
}

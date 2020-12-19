import 'package:weather_forecast/data/weather_api_client.dart';
import 'package:weather_forecast/locator.dart';
import 'package:weather_forecast/models/weather.dart';

class WeatherRepository {
  WeatherApiClient weatherApiClient = locator<WeatherApiClient>();
  Future<Weather> getWeather(String sehir) async {
    final int sehirID = await weatherApiClient.getLocationID(sehir);
    return await weatherApiClient.getWeather(sehirID);
  }
}

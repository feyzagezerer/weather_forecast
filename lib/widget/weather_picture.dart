import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/viewmodels/weather_view_model.dart';

class WeatherPictureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _weatherViewModel = Provider.of<WeatherViewModel>(context);
    var havaDurumuKisaltmasi = _weatherViewModel
        .getirilenWeather.consolidatedWeather[0].weatherStateAbbr;
    return Column(
      children: <Widget>[
        Text(
          _weatherViewModel.getirilenWeather.consolidatedWeather[0].theTemp
                  .floor()
                  .toString() +
              " ℃",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Image.network(
          "https://www.metaweather.com/static/img/weather/png/" +
              havaDurumuKisaltmasi +
              ".png",
          width: 150,
          height: 150,
        )
      ],
    );
  }
}

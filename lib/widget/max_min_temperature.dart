import 'package:flutter/material.dart';
import 'package:weather_forecast/models/weather.dart';

class MaxMinTemperatureWidget extends StatelessWidget {
  ConsolidatedWeather bugununDegerleri;

  MaxMinTemperatureWidget({this.bugununDegerleri});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Maximum : " + bugununDegerleri.maxTemp.floor().toString() + " ℃",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Minimum  : " + bugununDegerleri.minTemp.floor().toString() + " ℃",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

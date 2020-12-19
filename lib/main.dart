import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/locator.dart';
import 'package:weather_forecast/viewmodels/my_theme_view_model.dart';
import 'package:weather_forecast/viewmodels/weather_view_model.dart';
import 'package:weather_forecast/widget/weather_app.dart';

void main() {
  setupLocator();
  runApp(ChangeNotifierProvider(
      create: (context) => MyThemeViewModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyThemeViewModel>(
      builder: (context, MyThemeViewModel myThemeViewModel, child) =>
          MaterialApp(
        title: 'Weather Forecast',
        debugShowCheckedModeBanner: false,
        theme: myThemeViewModel.myTheme.tema,
        home: ChangeNotifierProvider<WeatherViewModel>(
            create: (context) => locator<WeatherViewModel>(),
            child: WeatherApp()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/locator.dart';
import 'package:weather_forecast/viewmodels/my_theme_view_model.dart';
import 'package:weather_forecast/viewmodels/weather_view_model.dart';
import 'package:weather_forecast/widget/weather_app.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) {
    debugPrint("Native called background task: $taskName");

    final now = DateTime.now();
    return Future.wait<bool>([
      HomeWidget.saveWidgetData('title', 'Updated from Background'),
      HomeWidget.saveWidgetData('message',
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}'),
      HomeWidget.updateWidget(
          name: 'HomeScreenWidgetProvider', iOSName: 'HomeWidgetExample'),
    ]).then((value) {
      return !value.contains(false);
    });
  });
}

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher);
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

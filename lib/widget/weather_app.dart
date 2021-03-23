import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/viewmodels/my_theme_view_model.dart';
import 'package:weather_forecast/viewmodels/weather_view_model.dart';
import 'package:weather_forecast/widget/city_select.dart';
import 'package:weather_forecast/widget/last_update.dart';
import 'package:weather_forecast/widget/location.dart';
import 'package:weather_forecast/widget/max_min_temperature.dart';
import 'package:weather_forecast/widget/transitive_background_color.dart';
import 'package:weather_forecast/widget/weather_picture.dart';
import 'package:workmanager/workmanager.dart';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String kullanicininSectigiSehir = "Ankara";
  WeatherViewModel _weatherViewModel;

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId('YOUR_GROUP_ID');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _startBackgroundUpdate() {
    Workmanager.registerPeriodicTask('1', 'widgetBackgroundUpdate',
        frequency: Duration(minutes: 15));
  }

  void _stopBackgroundUpdate() {
    Workmanager.cancelByUniqueName('1');
  }

  _havaDurumuListe() {
    return Expanded(
      child: Text(
        "\tWelcome to Weather Forecast, which receives weather forecasts from a variety of weather forecasters and calculates the most likely result and shows you. ",
        // MetaWeather is an automated weather data aggregator that takes the weather predictions from various forecasters and calculates the most likely outcome.
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _sendData() async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('City', _titleController.text),
        HomeWidget.saveWidgetData('message', HavaDurumuGeldi()),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  Future<void> _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'HomeScreenWidgetProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<void> _loadData() async {
    try {
      return Future.wait([
        HomeWidget.getWidgetData<String>('title', defaultValue: 'Default Title')
            .then((value) => _titleController.text = value),
        HomeWidget.getWidgetData<String>('message',
                defaultValue: 'Default Message')
            .then((value) => _messageController.text = value),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
  }

  @override
  Widget build(BuildContext context) {
    _weatherViewModel = Provider.of<WeatherViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Forecast"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                kullanicininSectigiSehir = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CitySelectWidget()));
                //debugPrint("Seçilen sehir: " + kullanicininSectigiSehir);
                _weatherViewModel.havaDurumunuGetir(kullanicininSectigiSehir);
              }),
        ],
      ),
      body: Center(
        child: (_weatherViewModel.state == WeatherState.WeatherLoadedState)
            ? HavaDurumuGeldi()
            : (_weatherViewModel.state == WeatherState.WeatherLoadingState)
                ? havaDurumuGetiriliyor()
                : (_weatherViewModel.state == WeatherState.WeatherErrorState)
                    ? havaDurumuGetirHata()
                    : Center(
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Title',
                              ),
                              controller: _titleController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Body',
                              ),
                              controller: _messageController,
                            ),
                            ElevatedButton(
                              onPressed: _sendAndUpdate,
                              child: Text('Send Data to Widget'),
                            ),
                            ElevatedButton(
                              onPressed: _loadData,
                              child: Text('Load Data'),
                            ),
                            if (Platform.isAndroid)
                              ElevatedButton(
                                onPressed: _startBackgroundUpdate,
                                child: Text('Update in background'),
                              ),
                            if (Platform.isAndroid)
                              ElevatedButton(
                                onPressed: _stopBackgroundUpdate,
                                child: Text('Stop updating in background'),
                              )
                          ],
                        ),
                      ),
      ),
    );
  }

  havaDurumuGetiriliyor() {
    return CircularProgressIndicator();
  }

  havaDurumuGetirHata() {
    return Text("Data failed to fetch");
  }
}

class HavaDurumuGeldi extends StatefulWidget {
  @override
  _HavaDurumuGeldiState createState() => _HavaDurumuGeldiState();
}

class _HavaDurumuGeldiState extends State<HavaDurumuGeldi> {
  WeatherViewModel _weatherViewModel;
  Completer<void> _refreshIndicator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshIndicator = Completer<void>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var kisaltma = Provider.of<WeatherViewModel>(context, listen: false)
          .havaDurumuKisaltmasi();

      Provider.of<MyThemeViewModel>(context, listen: false)
          .temaDegistir(kisaltma);
    });
  }

  @override
  Widget build(BuildContext context) {
    _refreshIndicator.complete();
    _refreshIndicator = Completer<void>();

    _weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    String kullanicininSectigiSehir = _weatherViewModel.getirilenWeather.title;

    return GecisliRenkContainer(
      renk: Provider.of<MyThemeViewModel>(context, listen: false).myTheme.renk,
      child: RefreshIndicator(
        onRefresh: () {
          _weatherViewModel.havaDurumunuGuncelle(kullanicininSectigiSehir);
          return _refreshIndicator.future;
        },
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: LocationWidget(
                secilenSehir: kullanicininSectigiSehir,
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: LastUpdateWidget()), //parametresiz
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: WeatherPictureWidget()),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  16.0), //getirilen hava durumunu parametre olarak
              child: Center(
                  child: MaxMinTemperatureWidget(
                bugununDegerleri:
                    _weatherViewModel.getirilenWeather.consolidatedWeather[0],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

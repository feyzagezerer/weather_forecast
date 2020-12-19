import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/viewmodels/my_theme_view_model.dart';
import 'package:weather_forecast/viewmodels/weather_view_model.dart';
import 'package:weather_forecast/widget/city_select.dart';
import 'package:weather_forecast/widget/last_update.dart';
import 'package:weather_forecast/widget/location.dart';
import 'package:weather_forecast/widget/max_min_temperature.dart';
import 'package:weather_forecast/widget/transitive_background_color.dart';
import 'package:weather_forecast/widget/weather_picture.dart';

class WeatherApp extends StatelessWidget {
  String kullanicininSectigiSehir = "Ankara";
  WeatherViewModel _weatherViewModel;

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
                    : Text(
                        "\tWelcome to Weather Forecast, which receives weather forecasts from a variety of weather forecasters and calculates the most likely result and shows you. "
                        "\n\n\tType the name of the city whose weather you want to know in the search field above."
                        "\n\n\tYou can find information about the weather forecast of big cities, especially capital cities.",
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
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

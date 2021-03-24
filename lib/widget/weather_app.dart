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

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String kullanicininSectigiSehir = "Ankara";
  WeatherViewModel _weatherViewModel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String _selectedCity;

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
                    : Form(
                        key: this._formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(35, 30, 35, 15),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "\tWelcome to \nWeather Forecast, \nwhich receives weather forecasts from a variety of weather forecasters and calculates the most likely result and shows you. ",
                                // Weather Forecast is an automated weather data aggregator that takes the weather predictions from various forecasters and calculates the most likely outcome.
                                style: TextStyle(fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),

                              /*  TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    hintText: 'Write city name...',
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: this._typeAheadController,
                                ),
                                suggestionsCallback: (pattern) {
                                  return City.getSuggestions(pattern);
                                },
                                itemBuilder: (context, String suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (String suggestion) {
                                  this._typeAheadController.text = suggestion;
                                },
                                validator: (value) => value.isEmpty
                                    ? 'Please select a city'
                                    : null,
                                onSaved: (value) => this._selectedCity = value,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                             FloatingActionButton(
                                onPressed: () {
                                  newPage(_selectedCity);
                                },
                                heroTag: "Add City",
                                tooltip: "Add City",
                                child: Icon(Icons.add_to_photos_rounded,
                                    color: Colors.white, size: 30.0),
                                mini: true,
                                backgroundColor: Colors.blue,
                              ),*/
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }

  /*newPage(_selectedCity) {
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
                    : Form(
                        key: this._formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    hintText: 'Write city name...',
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: this._typeAheadController,
                                ),
                                suggestionsCallback: (pattern) {
                                  return City.getSuggestions(pattern);
                                },
                                itemBuilder: (context, String suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (String suggestion) {
                                  this._typeAheadController.text = suggestion;
                                },
                                validator: (value) => value.isEmpty
                                    ? 'Please select a city'
                                    : null,
                                onSaved: (value) => this._selectedCity = value,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  newPage(_selectedCity);
                                },
                                heroTag: "Add City",
                                tooltip: "Add City",
                                child: Icon(Icons.add_to_photos_rounded,
                                    color: Colors.white, size: 30.0),
                                mini: true,
                                backgroundColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }*/

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

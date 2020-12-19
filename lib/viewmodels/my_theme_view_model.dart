import 'package:flutter/material.dart';
import 'package:weather_forecast/models/my_theme.dart';

class MyThemeViewModel with ChangeNotifier {
  MyTheme _myTheme;

  MyThemeViewModel() {
    _myTheme = MyTheme(Colors.blue, ThemeData.light());
  }

  MyTheme get myTheme => _myTheme;

  set myTheme(MyTheme value) {
    _myTheme = value;
    notifyListeners();
  }

  void temaDegistir(String havaDurumuKisaltmasi) {
    MyTheme _geciciTema;

    switch (havaDurumuKisaltmasi) {
      case "sn": //karlı
      case "sl": //sulu kar
      case "h": //dolu

        _geciciTema =
            MyTheme(Colors.cyan, ThemeData(primaryColor: Colors.blueGrey));
        break;

      case "t": //fırtına
      case "hc": //çok bulutlu
        _geciciTema = MyTheme(
            Colors.grey, ThemeData(primaryColor: Colors.blueGrey.shade700));

        break;

      case "lc": //az bulutlu
        _geciciTema =
            MyTheme(Colors.yellow, ThemeData(primaryColor: Colors.amber));
        break;

      case "hr": //ağır yagmurlu
      case "s": // sağanak yagıs
        _geciciTema = MyTheme(
            Colors.indigo, ThemeData(primaryColor: Colors.indigo.shade800));
        break;

      case "lr": //hafif yagmurlu
        _geciciTema =
            MyTheme(Colors.blue, ThemeData(primaryColor: Colors.indigoAccent));
        break;

      case "c": //açık güneşli hava
        _geciciTema =
            MyTheme(Colors.amber, ThemeData(primaryColor: Colors.orangeAccent));
        break;
    }

    myTheme = _geciciTema;
  }
}

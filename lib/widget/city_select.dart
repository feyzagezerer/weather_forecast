import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather_forecast/models/city.dart';

class CitySelectWidget extends StatefulWidget {
  @override
  _CitySelectWidgetState createState() => _CitySelectWidgetState();
}

class _CitySelectWidgetState extends State<CitySelectWidget> {
  final _textController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("City Select"),
      ),
      body: Form(
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
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (String suggestion) {
                  this._typeAheadController.text = suggestion;
                },
                validator: (value) =>
                    value.isEmpty ? 'Please select a city' : null,
                onSaved: (value) => this._selectedCity = value,
              ),
              /*Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      hintText: 'Write city name...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),*/
              SizedBox(
                height: 8.0,
              ),
              RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Text('Search'),
                  onPressed: () {
                    Navigator.pop(context, _typeAheadController.text);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

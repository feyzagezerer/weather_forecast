import 'package:flutter/material.dart';

class CitySelectWidget extends StatefulWidget {
  @override
  _CitySelectWidgetState createState() => _CitySelectWidgetState();
}

class _CitySelectWidgetState extends State<CitySelectWidget> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("City Select"),
      ),
      body: Form(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
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
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pop(context, _textController.text);
              })
        ],
      )),
    );
  }
}

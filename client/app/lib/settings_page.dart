import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'globals.dart' as globals;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _active1 = false;
  //bool _active2 = false;
  //bool _active3 = false;
  //bool _active4 = false;

  _switchListTile() => SwitchListTile(
        title: const Text('Room 1'),
        value: _active1,
        onChanged: (bool value) async {
          setState(() {
            _active1 = value;
          });

          switch (value) {
            case true:
              var response = await http.post(globals.url + "subscriptions/",
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': globals.tokenMeasurify,
                  },
                  body: convert.jsonEncode(<String, String>{
                    'token': globals.tokenFirebase,
                    'thing': "my-room",
                    "device": "presence-detector"
                  }));

              if (response.statusCode == 200) {
                await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Succes!'),
                        content: Text('Subscription is done correctly.'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
              } else {
                await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text("Subscription isn't done."),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('RETRY'),
                          ),
                        ],
                      );
                    });
              }
              break;
            case false:
              var response = await http.delete(
                globals.url + "subscriptions/",
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': globals.tokenMeasurify,
                },
                /*
                  body: convert.jsonEncode(<String, String>{
                    'token': globals.tokenFirebase,
                    'thing': "my-room",
                    "device": "presence-detector"
                  })*/
              );

              if (response.statusCode == 200) {
                await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Succes!'),
                        content: Text('Subscription is done correctly.'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
              } else {
                await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text("Subscription isn't done."),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('RETRY'),
                          ),
                        ],
                      );
                    });
              }
              break;
            default:
          }
        },
        secondary: const Icon(Icons.room_service),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _switchListTile(),
      /*SwitchListTile(
        title: const Text('Room 2'),
        value: _active2,
        onChanged: (bool value) {
          setState(() {
            _active2 = value;
          });
        },
        secondary: const Icon(Icons.room_service),
      ),
      SwitchListTile(
        title: const Text('Room 3'),
        value: _active3,
        onChanged: (bool value) {
          setState(() {
            _active3 = value;
          });
        },
        secondary: const Icon(Icons.room_service),
      ),
      SwitchListTile(
        title: const Text('Room 4'),
        value: _active4,
        onChanged: (bool value) {
          setState(() {
            _active4 = value;
          });
        },
        secondary: const Icon(Icons.room_service),
      ),*/
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'globals.dart' as globals;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';

class RoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  var res_body;

  Future createTabRoomPage() async {
    //faccio la chiamata http. alla route /thing
    var response =
        await http.get(globals.url + "/things", headers: <String, String>{
      'Authorization': globals.tokenMeasurify,
    });
    //print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      //print(jsonResponse);
      //jsonResponse = jsonResponse[0];
      return jsonResponse;
    } else
      return "error";
  }

  @override
  void initState() {
    // This is the proper place to make the async calls
    // This way they only get called once

    // During development, if you change this code,
    // you will need to do a full restart instead of just a hot reload

    // You can't use async/await here, because
    // We can't mark this method as async because of the @override
    // You could also make and call an async method that does the following
    createTabRoomPage().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        res_body = result;
      });
    });
  }

  List createTabs() {
    var list = [
      Tab(
          text: convert
              .jsonDecode(convert.jsonEncode(convert.jsonDecode(
                  convert.jsonEncode(this.res_body['docs']))[0]))['_id']
              .toString(),
          icon: Icon(Icons.room_service))
    ];

    for (var i = 1; i < this.res_body['totalDocs']; i++) {
      list.add(Tab(
          text: convert
              .jsonDecode(convert.jsonEncode(convert.jsonDecode(
                  convert.jsonEncode(this.res_body['docs']))[i]))['_id']
              .toString(),
          icon: Icon(Icons.room_service)));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (res_body == null) {
      // This is what we show while we're loading
      return new Container();
    }

    // Do something with the `_result`s h
    print("res body is : " + res_body['totalDocs'].toString());
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
      ),
      home: DefaultTabController(
        length: res_body['totalDocs'],
        child: Scaffold(
          appBar: TabBar(tabs: createTabs()),
          body: TabBarView(
            children: [
              createBodyForMyRoom(),
              //Mybottom(),
              //Mybottom(),
              //Mybottom(),
            ],
          ),
          floatingActionButton: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(secondary: Colors.lightBlue),
            ),
            child: FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}

Widget createBodyForMyRoom() {
  return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
      child: SizedBox(
          height: 210,
          child: Card(
              child: Column(children: [
            ListTile(
              title: Text('Device ID: presence-detector',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('feature: presence'),
              leading: Icon(
                Icons.sensor_door_outlined,
                color: Colors.blue[500],
              ),
            ),
            Divider(),
            Mybottom()
          ]))));
}

class Mybottom extends StatelessWidget {
  Mybottom({Key key}) : super(key: key);

  Widget _buildList(var body) => ListView(
        children: createNotificationsListWidget(body),
      );

  List createNotificationsListWidget(var body) {
    ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
          title: Text("sensor ID: " + title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
          subtitle: Text("timestamp: " + subtitle),
          leading: Icon(
            icon,
            color: Colors.white,
          ),
        );

    var list = [
      _tile(
          convert
              .jsonDecode(convert.jsonEncode(convert
                  .jsonDecode(convert.jsonEncode(body['docs']))[0]))['device']
              .toString(),
          convert
              .jsonDecode(convert.jsonEncode(convert
                  .jsonDecode(convert.jsonEncode(body['docs']))[0]))['endDate']
              .toString(),
          Icons.history_outlined),
      Divider()
    ];

    for (var i = 1; i < body['limit']; i++) {
      list.add(_tile(
          convert
              .jsonDecode(convert.jsonEncode(convert
                  .jsonDecode(convert.jsonEncode(body['docs']))[i]))['device']
              .toString(),
          convert
              .jsonDecode(convert.jsonEncode(convert
                  .jsonDecode(convert.jsonEncode(body['docs']))[i]))['endDate']
              .toString(),
          Icons.history_outlined));
      list.add(Divider());
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: RaisedButton(
            child: const Text('Notifications'),
            onPressed: () async {
              var response = await http.get(
                  globals.url +
                      '/measurements?filter={"thing": "my-room"}&limit=10&page=1',
                  headers: <String, String>{
                    'Authorization': globals.tokenMeasurify,
                  });

              if (response.statusCode == 200) {
                var jsonResponse = convert.jsonDecode(response.body);
                //faccio diventare la risposta JSON come una lista
                //jsonResponse = jsonResponse[0];

                Scaffold.of(context).showBottomSheet<void>(
                  (BuildContext context) {
                    return Container(
                      height: 300,
                      color: Colors.blueAccent,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                height: 252, child: _buildList(jsonResponse)),
                            Align(
                                alignment: Alignment(0.9, 1.0),
                                child: TextButton(
                                    child: Text(
                                      'CLOSE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context))),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text('Error. Please try again.'),
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
              }
            }));
  }

  //END CLASS RoomPageState
}

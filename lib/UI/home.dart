import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _enteredCity;

  // use this to know if the api is being called or if you are working on the voidMain page

//  void showStuff() async {
//    Map data = await getWeather(util.appId, util.defaultCity);
//    print(data.toString());
//  }

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
      return ChangeCity();
    }));
    if (results != null && results.containsKey("enter")) {
      setState(() {
        _enteredCity = results["enter"].toString();
      });
      print(_enteredCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("home $_enteredCity");

    return Scaffold(
      appBar: AppBar(
        title: Text("Klimatik"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _goToNextScreen(context);
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "images/umbrella.png",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.0, 0.0),
            child: Text(
              _enteredCity == null ? util.defaultCity : _enteredCity,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png"),
          ),
          // container to contain weather data
          Container(
            child: updateTempWidget(_enteredCity),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appID, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=imperial";

    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    //print("update $city");
    return FutureBuilder(
      future: getWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(50.0, 390.0, 0.0, 0.0),
                    title: Text(
                      content["main"]["temp"].toString() + "F",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 39.9,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    subtitle: Text("Feels Like: ${content["main"]["feels_like"].toString()}F\n"
                        "Minimum Temp: ${content["main"]["temp_min"].toString()}F\n"
                        "Maximum Temp: ${content["main"]["temp_max"].toString()}F\n"
                        "Humidity: ${content["main"]["humidity"].toString()}",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                    ),),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            child: Text(""),
          );
        }
      },
    );
  }
}

class ChangeCity extends StatefulWidget {
  @override
  _ChangeCityState createState() => _ChangeCityState();
}

class _ChangeCityState extends State<ChangeCity> {
  TextEditingController _cityFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Change City"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "images/snoww.jpg",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter City",
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {"enter": _cityFieldController.text});
                  },
                  color: Colors.transparent,
                  child: Text("Get Weather"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

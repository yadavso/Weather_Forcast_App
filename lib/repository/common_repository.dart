import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_forcast_project/helper/Api.dart';
import 'package:http/http.dart' as http;

import '../models/Geocoding_model.dart';
import '../models/WeatherData_model.dart';

Future<WeatherData> get_Hourly_Temp() async {
  WeatherData? responseModel;
  String temp =
      '&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,precipitation,weathercode,visibility,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset&timezone=auto';
  String url = '${Api.baseUrl}latitude=${Api.lat}&longitude=${Api.lon}$temp';
  var uri = Uri.parse(url);
  var response = await http.get(uri);
  // print(url);
  // print(response.statusCode);
  if (response.statusCode == 200) {
    responseModel = WeatherData.fromJson(json.decode(response.body));
  }
  return responseModel!;
}

Future<Geocoding> get_geocoding(BuildContext context) async {
  showProgressDialog(context);
  Geocoding? responseModel;
  String url = '${Api.gUrl}${Api.name}';
  var uri = Uri.parse(url);
  var response = await http.get(uri);
  print(response.statusCode);
  if (response.statusCode == 200) {
    responseModel = Geocoding.fromJson(json.decode(response.body));
  }
  Navigator.pop(context);
  return responseModel!;
}

showProgressDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7), child: Text("Please wait...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

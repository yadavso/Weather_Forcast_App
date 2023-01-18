import 'dart:core';

//https://api.open-meteo.com/v1/forecast?latitude=21.11&longitude=79.05&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,precipitation,weathercode,visibility,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset&timezone=auto

class Api {
  //Base Url
  static double lat = 0.0;
  static double lon = 0.0;

  static String baseUrl = "https://api.open-meteo.com/v1/forecast?";
  //Latitude and Long
  static String locationUrl = "${baseUrl}latitude=$lat&longitude=$lon";

  // String tempData =
  //     "$locationUrl&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,precipitation,weathercode,visibility,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset&timezone=auto";
}

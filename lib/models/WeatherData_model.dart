class WeatherData {
  double? latitude;
  double? longitude;
  double? generationtimeMs;
  int? utcOffsetSeconds;
  String? timezone;
  String? timezoneAbbreviation;
  double? elevation;
  HourlyUnits? hourlyUnits;
  Hourly? hourly;
  DailyUnits? dailyUnits;
  Daily? daily;

  WeatherData(
      {this.latitude,
      this.longitude,
      this.generationtimeMs,
      this.utcOffsetSeconds,
      this.timezone,
      this.timezoneAbbreviation,
      this.elevation,
      this.hourlyUnits,
      this.hourly,
      this.dailyUnits,
      this.daily});

  WeatherData.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    elevation = json['elevation'];
    hourlyUnits = json['hourly_units'] != null
        ? HourlyUnits.fromJson(json['hourly_units'])
        : null;
    hourly = json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null;
    dailyUnits = json['daily_units'] != null
        ? DailyUnits.fromJson(json['daily_units'])
        : null;
    daily = json['daily'] != null ? Daily.fromJson(json['daily']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['generationtime_ms'] = generationtimeMs;
    data['utc_offset_seconds'] = utcOffsetSeconds;
    data['timezone'] = timezone;
    data['timezone_abbreviation'] = timezoneAbbreviation;
    data['elevation'] = elevation;
    if (hourlyUnits != null) {
      data['hourly_units'] = hourlyUnits!.toJson();
    }
    if (hourly != null) {
      data['hourly'] = hourly!.toJson();
    }
    if (dailyUnits != null) {
      data['daily_units'] = dailyUnits!.toJson();
    }
    if (daily != null) {
      data['daily'] = daily!.toJson();
    }
    return data;
  }
}

class HourlyUnits {
  String? time;
  String? temperature2m;
  String? relativehumidity2m;
  String? apparentTemperature;
  String? precipitation;
  String? weathercode;
  String? visibility;
  String? windspeed10m;

  HourlyUnits(
      {this.time,
      this.temperature2m,
      this.relativehumidity2m,
      this.apparentTemperature,
      this.precipitation,
      this.weathercode,
      this.visibility,
      this.windspeed10m});

  HourlyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature2m = json['temperature_2m'];
    relativehumidity2m = json['relativehumidity_2m'];
    apparentTemperature = json['apparent_temperature'];
    precipitation = json['precipitation'];
    weathercode = json['weathercode'];
    visibility = json['visibility'];
    windspeed10m = json['windspeed_10m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['time'] = time;
    data['temperature_2m'] = temperature2m;
    data['relativehumidity_2m'] = relativehumidity2m;
    data['apparent_temperature'] = apparentTemperature;
    data['precipitation'] = precipitation;
    data['weathercode'] = weathercode;
    data['visibility'] = visibility;
    data['windspeed_10m'] = windspeed10m;
    return data;
  }
}

class Hourly {
  List<String>? time;
  List<double>? temperature2m;
  List<int>? relativehumidity2m;
  List<double>? apparentTemperature;
  List<int>? precipitation;
  List<int>? weathercode;
  List<double>? visibility;
  List<double>? windspeed10m;

  Hourly(
      {this.time,
      this.temperature2m,
      this.relativehumidity2m,
      this.apparentTemperature,
      this.precipitation,
      this.weathercode,
      this.visibility,
      this.windspeed10m});

  Hourly.fromJson(Map<String, dynamic> json) {
    time = json['time'].cast<String>();
    temperature2m = json['temperature_2m'].cast<double>();
    relativehumidity2m = json['relativehumidity_2m'].cast<int>();
    apparentTemperature = json['apparent_temperature'].cast<double>();
    precipitation = json['precipitation'].cast<int>();
    weathercode = json['weathercode'].cast<int>();
    visibility = json['visibility'].cast<double>();
    windspeed10m = json['windspeed_10m'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['time'] = time;
    data['temperature_2m'] = temperature2m;
    data['relativehumidity_2m'] = relativehumidity2m;
    data['apparent_temperature'] = apparentTemperature;
    data['precipitation'] = precipitation;
    data['weathercode'] = weathercode;
    data['visibility'] = visibility;
    data['windspeed_10m'] = windspeed10m;
    return data;
  }
}

class DailyUnits {
  String? time;
  String? weathercode;
  String? temperature2mMax;
  String? temperature2mMin;
  String? apparentTemperatureMax;
  String? apparentTemperatureMin;
  String? sunrise;
  String? sunset;

  DailyUnits(
      {this.time,
      this.weathercode,
      this.temperature2mMax,
      this.temperature2mMin,
      this.apparentTemperatureMax,
      this.apparentTemperatureMin,
      this.sunrise,
      this.sunset});

  DailyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    weathercode = json['weathercode'];
    temperature2mMax = json['temperature_2m_max'];
    temperature2mMin = json['temperature_2m_min'];
    apparentTemperatureMax = json['apparent_temperature_max'];
    apparentTemperatureMin = json['apparent_temperature_min'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['time'] = time;
    data['weathercode'] = weathercode;
    data['temperature_2m_max'] = temperature2mMax;
    data['temperature_2m_min'] = temperature2mMin;
    data['apparent_temperature_max'] = apparentTemperatureMax;
    data['apparent_temperature_min'] = apparentTemperatureMin;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }
}

class Daily {
  List<String>? time;
  List<int>? weathercode;
  List<double>? temperature2mMax;
  List<double>? temperature2mMin;
  List<double>? apparentTemperatureMax;
  List<double>? apparentTemperatureMin;
  List<String>? sunrise;
  List<String>? sunset;

  Daily(
      {this.time,
      this.weathercode,
      this.temperature2mMax,
      this.temperature2mMin,
      this.apparentTemperatureMax,
      this.apparentTemperatureMin,
      this.sunrise,
      this.sunset});

  Daily.fromJson(Map<String, dynamic> json) {
    time = json['time'].cast<String>();
    weathercode = json['weathercode'].cast<int>();
    temperature2mMax = json['temperature_2m_max'].cast<double>();
    temperature2mMin = json['temperature_2m_min'].cast<double>();
    apparentTemperatureMax = json['apparent_temperature_max'].cast<double>();
    apparentTemperatureMin = json['apparent_temperature_min'].cast<double>();
    sunrise = json['sunrise'].cast<String>();
    sunset = json['sunset'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['time'] = time;
    data['weathercode'] = weathercode;
    data['temperature_2m_max'] = temperature2mMax;
    data['temperature_2m_min'] = temperature2mMin;
    data['apparent_temperature_max'] = apparentTemperatureMax;
    data['apparent_temperature_min'] = apparentTemperatureMin;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }
}

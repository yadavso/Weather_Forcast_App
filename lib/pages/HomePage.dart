import 'dart:async';

// import 'dart:math';
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_forcast_project/helper/Api.dart';
import 'package:weather_forcast_project/models/WeatherData_model.dart';
import 'package:weather_forcast_project/pages/searchPage.dart';
import 'package:weather_forcast_project/pages/settingsPage.dart';
import 'package:weather_forcast_project/repository/common_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  String? _currentAddress = '';
  Position? _currentPosition;

  String sunrise = 'day';
  double? screenHeight;
  double? screenWidth;
  String cdate = DateFormat("EEE").format(DateTime.now());
  String cTime = DateFormat("hh:mm:ss a").format(DateTime.now());
  String ct = DateTime.now().toString();
  String cHour = DateFormat("HH").format(DateTime.now());

// Weather Data
  double? long;
  List<double> hApparentTemperature = [];
  List<double> hWindspeed = [];
  List<String> hTime = [];
  List<String> dTime = [];
  List<double> htemperature = [];
  List<double> max_temp = [];
  List<double> min_temp = [];
  List<double> visibility = [];
  List<int> hHumidity = [];
  List<int> wcode = [];
  List<String> sun = [];
  List<String> set = [];
// 00 if null
  double _temp = 00.0;
  double _feelsLike = 00.0;
  String _max_temp = '00';
  String _min_temp = '00';
  String _hWind = '00';
  String _hHumid = '00';
  String _visibility = '00 km';
  // String _sun = '00';
  // String _set = '00';
  int _wcode = 0;

  @override
  void initState() {
    // TODO: implement initState

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    _isSunrise();
    start();

    // locale notification
    //super.initState();
  }

  Future<void> notificationInitialize() async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        new InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  start() async {
    if (Api.lat == 0.0 && Api.lon == 0.0) {
      await _getCurrentPosition();
      await get_temp();
    } else {
      await get_temp();
    }
    _getAddressFromLatLng();
    // await notificationInitialize();
  }

  get_temp() async {
    WeatherData responseModel = await get_Hourly_Temp();
    long = responseModel.longitude;
    hApparentTemperature = responseModel.hourly!.apparentTemperature!;
    hTime = responseModel.hourly!.time!;
    dTime = responseModel.daily!.time!;
    htemperature = responseModel.hourly!.temperature2m!;
    hWindspeed = responseModel.hourly!.windspeed10m!;
    hHumidity = responseModel.hourly!.relativehumidity2m!;
    max_temp = responseModel.daily!.temperature2mMax!;
    min_temp = responseModel.daily!.temperature2mMin!;
    visibility = responseModel.hourly!.visibility!;
    wcode = responseModel.hourly!.weathercode!;
    sun = responseModel.daily!.sunrise!;
    set = responseModel.daily!.sunset!;

    // 00 if null
    _temp = htemperature[int.parse(cHour)];
    _feelsLike = hApparentTemperature[int.parse(cHour)];
    _max_temp = max_temp[0].round().toString();
    _min_temp = min_temp[0].round().toString();
    _hWind = '${hWindspeed[int.parse(cHour)]} km/h';
    _hHumid = '${hHumidity[int.parse(cHour)]}%';
    _visibility = '${visibility[int.parse(cHour)] / 1000} km';
    _wcode = wcode[int.parse(cHour)];
    // _sun = sun[0].substring(11, 16);
    // _set = set[0].substring(11, 16);
    print('longitude - ' + Api.lon.toString());
    print('latitude - ' + Api.lat.toString());
    print('URL - ' + Api.locationUrl);

    setState(() {});
  }

  void _getCurrentTime() {
    setState(() {
      cTime = DateFormat("hh:mm:ss a").format(DateTime.now());
    });
  }

  void dispose() {
    super.dispose();
  }

  String wStatus(int code) {
    if (code == 0) {
      return 'Clear Sky';
    } else if (code == 1) {
      return 'Mainly Clear';
    } else if (code == 2) {
      return 'Partly Cloudy';
    } else if (code == 3) {
      return 'Overcast';
    } else {
      return "Null";
    }
  }

  void _isSunrise() {
    int cHour_Int = int.parse(cHour);
    if (cHour_Int >= 6 && cHour_Int <= 17) {
      setState(() {
        sunrise = 'day';
      });
    } else {
      setState(() {
        sunrise = 'night';
      });
    }
    print(sunrise);
  }

  Future<void> _refresh() async {
    await get_temp();
  }

// Location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  //Get current location
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
    setState(() {
      Api.lat = _currentPosition!.latitude;
      Api.lon = _currentPosition!.longitude;
    });
    print(_currentPosition);
  }

  // get address from lat and long
  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(Api.lat, Api.lon)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = place.locality;
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future _showNotificationOnClick() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        playSound: true, importance: Importance.high, priority: Priority.high);

    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Todays Temperature',
      '$_temp°C',
      platformChannelSpecifics,
      payload: 'No_Sound',
    );

    print('Notification displayed');
  }

  @override
  Widget build(BuildContext context) {
    // var currentHour = int.parse(cHour);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldState,
      drawer: AppDrawer(),
      body: Stack(children: [
        sunrise != 'day'
            ? Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 20, 35, 91),
                    Color.fromARGB(255, 149, 80, 161),
                  ],
                )),
              )
            : Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(130, 48, 86, 232),
                    Color.fromARGB(255, 139, 66, 155),
                  ],
                )),
              ),
        RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight! * 0.06,
                ),
                Stack(
                  children: [
                    Positioned(
                        child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: screenWidth! * 0.07,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _scaffoldState.currentState!.openDrawer();
                      },
                    )),
                    Center(
                      child: Container(
                        width: screenWidth! * 0.79,
                        child: Center(
                          child: Text(
                            _currentAddress!,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(fontSize: screenWidth! * 0.1),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: screenWidth! * 0.87,
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchPage()))
                                  .then((value) async => await start());
                            },
                            icon: Icon(
                              Icons.search,
                              size: screenWidth! * 0.08,
                              color: Colors.white,
                            )))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$cdate , $cTime',
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight! * 0.21,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(wStatus(_wcode),
                            style: TextStyle(fontSize: screenWidth! * 0.1)),
                        Text(
                          '${_temp.round()}°',
                          style: TextStyle(
                              fontSize: screenWidth! * 0.45,
                              fontFamily: 'Mollen',
                              fontWeight: FontWeight.w100),
                        )
                      ],
                    ),
                    SizedBox(
                      width: screenWidth! * 0.15,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: screenHeight! * 0.1,
                        ),
                        Text(
                          '$_max_temp°',
                          style: TextStyle(
                              fontSize: screenWidth! * 0.07,
                              fontFamily: 'Mollen',
                              fontWeight: FontWeight.w300),
                        ),
                        Container(
                          width: screenWidth! * 0.12,
                          child: Divider(
                            height: screenHeight! * 0.02,
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        Text(_min_temp + '°',
                            style: TextStyle(
                                fontSize: screenWidth! * 0.07,
                                fontFamily: 'Mollen',
                                fontWeight: FontWeight.w300))
                      ],
                    )
                  ],
                ),
                Container(
                  height: screenHeight! * 0.16,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 24,
                      itemBuilder: (BuildContext context, index) => long != null
                          ? hourly_Container(
                              htemperature[index].round().toString() + '°',
                              hTime[index].toString().substring(11, 16),
                              wcode[index],
                              hWindspeed[index].toString())
                          : Container()),
                ),
                SizedBox(
                  height: screenHeight! * 0.01,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth! * 0.04),
                      child: Text(
                        'DETAILS  ',
                        style: TextStyle(fontSize: screenWidth! * 0.036),
                      ),
                    ),
                    Container(
                      width: screenWidth! * 0.758,
                      child: Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight! * 0.03,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: screenWidth! * 0.04,
                    ),
                    Column(
                      children: [
                        detail_Container('assets/icons/values/temperature.png',
                            'Feels Like', '$_feelsLike°C'),
                        SizedBox(
                          height: screenHeight! * 0.015,
                        ),
                        detail_Container('assets/icons/values/eye.png',
                            'Visibility', _visibility)
                      ],
                    ),
                    SizedBox(
                      width: screenWidth! * 0.04,
                    ),
                    Column(
                      children: [
                        detail_Container('assets/icons/values/wind.png',
                            'Wind Speed', _hWind),
                        SizedBox(
                          height: screenHeight! * 0.015,
                        ),
                        detail_Container('assets/icons/values/min temp.png',
                            'Min Temp', '$_min_temp°C')
                      ],
                    ),
                    SizedBox(
                      width: screenWidth! * 0.04,
                    ),
                    Column(
                      children: [
                        detail_Container('assets/icons/values/humidity.png',
                            'Humidity', _hHumid),
                        SizedBox(
                          height: screenHeight! * 0.015,
                        ),
                        detail_Container('assets/icons/values/max temp.png',
                            'Max Temp', '$_max_temp°C')
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight! * 0.03,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth! * 0.04),
                      child: Text(
                        'NEXT 7 DAYS  ',
                        style: TextStyle(fontSize: screenWidth! * 0.036),
                      ),
                    ),
                    Container(
                      width: screenWidth! * 0.67,
                      child: Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight! * 0.03,
                ),
                Container(
                  height: screenHeight! * 0.19,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      //  padding:
                      //    EdgeInsets.symmetric(horizontal: screenWidth! * 0.01),
                      scrollDirection: Axis.horizontal,
                      itemCount: max_temp.length,
                      itemBuilder: (BuildContext context, index) => long != null
                          ? daily_Container(
                              wcode[index],
                              dTime[index],
                              min_temp[index].round().toString(),
                              max_temp[index].round().toString(),
                              index)
                          : Container()),
                ),
                SizedBox(
                  height: screenHeight! * 0.02,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget detail_Container(String icon, String text, String value) {
    return Container(
      height: screenHeight! * 0.13,
      width: screenWidth! * 0.28,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight! * 0.01),
            child: ImageIcon(
              AssetImage(icon),
              color: Colors.white,
              size: screenWidth! * 0.1,
            ),
          ),
          Text(text, style: TextStyle(fontSize: screenWidth! * 0.033)),
          Padding(
            padding: EdgeInsets.only(top: screenHeight! * 0.01),
            child: Text(value,
                style: TextStyle(
                    fontSize: screenWidth! * 0.05,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  imageAccordingToCode(int code) {
    if (code == 0) {
      return ('assets/icons/${sunrise}/clear sky.png');
    } else if (code == 1) {
      return 'assets/icons/${sunrise}/Mainly clear.png';
    } else if (code == 2) {
      return 'assets/icons/${sunrise}/partly.png';
    } else if (code == 3) {
      return 'assets/icons/${sunrise}/overcast.png';
    } else if (code == 45) {
      return 'assets/icons/${sunrise}/fog.png';
    } else {
      return 'assets/icons/${sunrise}/clear sky.png';
    }
  }

  Widget hourly_Container(
      String temp, String time, int code, String windSpeed) {
    var im = imageAccordingToCode(code);

    return Container(
        height: screenHeight! * 0.03,
        width: screenWidth! * 0.24,
        // decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10), color: Colors.white10),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: screenWidth! * 0.033),
            ),
            Text(temp, style: TextStyle(fontSize: screenWidth! * 0.06)),
            Image.asset(
              im,
              scale: screenWidth! * 0.003,
            ),
            Text(windSpeed + 'km/h',
                style: TextStyle(fontSize: screenWidth! * 0.031))
            //ImageIcon(AssetImage(im))
          ],
        ));
  }

  Widget daily_Container(int code, String date, String min, String max, index) {
    var im = imageAccordingToCode(code);
    return Container(
      margin: EdgeInsets.only(left: screenWidth! * 0.02),
      decoration: index == 0
          ? BoxDecoration(
              color: Colors.white10, borderRadius: BorderRadius.circular(10))
          : BoxDecoration(),
      width: screenWidth! * 0.143,
      child: Column(
        children: [
          SizedBox(
            height: screenHeight! * 0.01,
          ),
          Text(date.substring(8, 10) + '/' + date.substring(6, 7)),
          //index == 0 ? Text('Today') : Text(''),
          SizedBox(
            height: screenHeight! * 0.01,
          ),
          Image.asset(
            im,
            scale: screenWidth! * 0.003,
          ),
          SizedBox(
            height: screenHeight! * 0.016,
          ),
          Text(max, style: TextStyle(fontSize: screenWidth! * 0.049)),
          Container(
            width: screenWidth! * 0.05,
            child: Divider(
              thickness: 1,
              height: 2,
              color: Colors.white70,
            ),
          ),
          Text(
            min,
            style: TextStyle(
                fontSize: screenWidth! * 0.049, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget AppDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: screenHeight! * 0.23,
            child: DrawerHeader(
              curve: Curves.elasticIn,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(130, 48, 86, 232),
                  Color.fromARGB(255, 149, 80, 161),
                ],
              )),
              padding: EdgeInsets.all(0),
              // child: Container(
              //     width: screenWidth! * 0.9,
              //     child: Padding(
              //       padding: EdgeInsets.only(
              //           left: screenWidth! * 0.03, top: screenWidth! * 0.04),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          _currentAddress!,
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: screenWidth! * 0.09,
                              color: Colors.white),
                        ),
                        padding: EdgeInsets.only(
                            left: screenWidth! * 0.01,
                            top: screenHeight! * 0.015),
                        width: screenWidth! * 0.4,
                      ),
                      SizedBox(
                        height: screenHeight! * 0.01,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: screenWidth! * 0.01),
                        child: Text(
                          wStatus(_wcode),
                          style: TextStyle(
                              fontSize: screenWidth! * 0.05,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight! * 0.01,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: screenWidth! * 0.07,
                  ),
                  Column(
                    children: [
                      Image.asset(
                        imageAccordingToCode(_wcode),
                        scale: screenWidth! * 0.003,
                      ),
                      Text(
                        '$_temp° C',
                        style: TextStyle(
                            fontSize: screenWidth! * 0.06, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
              // )),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
            ),
          ),
          Divider(
            height: 0,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingPage(
                            temp: _temp,
                          )));
            },
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ),
          Divider(
            height: 0,
          ),
          ListTile(
            leading: Icon(Icons.star_border),
            title: Text('Rate Us'),
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}

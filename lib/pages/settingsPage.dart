import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key, required this.temp}) : super(key: key);

  final double temp;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var hourlyButton = false;
  var minuteButton = false;
  var dailyButton = false;
  var minuteButtonData;
  var hourlyButtonData;
  final animationDuration = Duration(milliseconds: 150);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      minuteButtonData = prefs.getBool('minuteButton');
      hourlyButtonData = prefs.getBool('hourlyButton');
    });
  }

  Future _showNotificationEveryMinute() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        playSound: true, importance: Importance.high, priority: Priority.high);

    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
        1,
        'Temperature',
        '${widget.temp} C',
        RepeatInterval.everyMinute,
        platformChannelSpecifics);
    print('Minute Notification enabled');
  }

  Future _showNotificationEveryHour() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        playSound: true, importance: Importance.high, priority: Priority.high);

    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(2, 'Temperature',
        '${widget.temp} C', RepeatInterval.hourly, platformChannelSpecifics);
    print('Hourly Notification enabled');
  }

  Future<void> cancelMinuteNotification() async {
    await flutterLocalNotificationsPlugin.cancel(1);
    print('Minute Notification disabled');
  }

  Future<void> cancelHourlyNotification() async {
    await flutterLocalNotificationsPlugin.cancel(2);
    print('hourly Notification disabled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color.fromARGB(130, 48, 86, 232),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState(() {
                hourlyButton = !hourlyButton;
              });
              await prefs.setBool('hourlyButton', hourlyButton);
              await getdata();
              hourlyButtonData
                  ? _showNotificationEveryHour()
                  : cancelHourlyNotification();
              //  _showNotificationOnClick();
            },
            child: ListTile(
              title: Text(
                'Hourly Notification',
                style: TextStyle(fontSize: 19),
              ),
              trailing: toggleButton(
                  hourlyButtonData != null ? hourlyButtonData : hourlyButton),
            ),
          ),
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState(() {
                minuteButton = !minuteButton;
              });
              await prefs.setBool('minuteButton', minuteButton);
              await getdata();
              minuteButtonData
                  ? _showNotificationEveryMinute()
                  : cancelMinuteNotification();
            },
            child: ListTile(
              title: Text(
                'Every Minute Notification',
                style: TextStyle(fontSize: 19),
              ),
              trailing: toggleButton(
                  minuteButtonData != null ? minuteButtonData : minuteButton),
            ),
          ),
          // toggleButton()
        ],
      ),
    );
  }

  Widget toggleButton(var button) {
    return AnimatedContainer(
      duration: animationDuration,
      height: 25,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: button ? Color(0x989DF83A) : Color(0xff565676),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: AnimatedAlign(
        alignment: button ? Alignment.centerRight : Alignment.centerLeft,
        duration: animationDuration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

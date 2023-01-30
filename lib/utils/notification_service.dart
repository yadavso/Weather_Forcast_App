import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
// If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// final StreamController<String?> selectNotificationStream =
//     StreamController<String?>.broadcast();
Future<void> initialize() async {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings =
      new InitializationSettings(android: initializationSettingsAndroid);
  //
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveNotificationResponse:
    //     (NotificationResponse notificationResponse) {
    //   switch (notificationResponse.notificationResponseType) {
    //     case NotificationResponseType.selectedNotification:
    //       selectNotificationStream.add(notificationResponse.payload);
    //       break;
    //     case NotificationResponseType.selectedNotificationAction:
    //       if (notificationResponse.actionId == navigationActionId) {
    //         selectNotificationStream.add(notificationResponse.payload);
    //       }
    //       break;
    //   }
    // },
  );
}

Future _showNotificationWithoutSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name',
      playSound: true, importance: Importance.high, priority: Priority.high);
  // var iOSPlatformChannelSpecifics =
  //     new IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = new NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Post',
    'How to Show Notification in Flutter',
    platformChannelSpecifics,
    payload: 'No_Sound',
  );
}

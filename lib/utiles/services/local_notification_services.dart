import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotificationServices {

  // initialization Notification
  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: false,
      badge: true,
      sound: true,
    );

    // click on notification
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onDidReceiveNotificationResponse: onTapNotification,
        onDidReceiveBackgroundNotificationResponse: onTapNotification
    );

  }


  // basic Notification
  static Future<void> showBasicNotification({
    required String title,
    required String body
  }) async {

    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      // for show notification in side app not in notification list {importance - priority}
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics
    );

    /// details of notification
    await FlutterLocalNotificationsPlugin().show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // repeated Notification
  static Future<void> showRepeatedNotification({
    required String title,
    required String body
  }) async {

    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      // for show notification in side app not in notification list {importance - priority}
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics
    );

    /// details of notification
    await FlutterLocalNotificationsPlugin().periodicallyShow(
      1,
      title,
      body,
      RepeatInterval.hourly,
      platformChannelSpecifics,
      // to ensure send notification if phone in save battery mode || use inexact if not necessary to show
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'item x',
    );
  }

  void cancelNotification(int id) async {
    await FlutterLocalNotificationsPlugin().cancel(id);
  }

}

/// click on notification
void onTapNotification(NotificationResponse notificationResponse) {

}

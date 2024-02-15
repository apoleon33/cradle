import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

/// Class to manage both shared preferences and local notifications.
class NotificationManagement {
  void addPushNotification(tz.TZDateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // https://stackoverflow.com/questions/39607856/what-is-notification-id-in-android
    int id = Random().nextInt(100);

    NotificationService().scheduleNotification(id, date);

    // save the notifications to be able to edit them
    prefs.setBool('${date.year}-${date.month}-${date.day}-pushStatus', true);
    prefs.setInt('${date.year}-${date.month}-${date.day}-id', id);
  }

  void removePushNotification(tz.TZDateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('${date.year}-${date.month}-${date.day}-id');
    final int id = prefs.getInt(
          '${date.year}-${date.month}-${date.day}-id',
        ) ??
        0;

    prefs.setBool('${date.year}-${date.month}-${date.day}-pushStatus', false);

    await NotificationService().cancelNotification(id);
  }

  /// Return true if a notification has been scheduled for the given day.
  Future<bool> isNotificationScheduledForThisDay(tz.TZDateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(
          '${date.year}-${date.month}-${date.day}-pushStatus',
        ) ??
        false;
  }
}

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    // the initialization settings are initialized after they are setted
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(int id, tz.TZDateTime date) async {
    if (kDebugMode) {
      print("sending notification...");
      print("notification scheduled for $date");
    }

    String title = "🎶There is a new album!";
    String body = "🎵 Click to see today's album.";

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      date,
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "ashwin",
            importance: Importance.max,
            priority: Priority.max),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    if (kDebugMode) {
      print("notification sent!");
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:net_carbons/notification/constants_classes.dart';
import 'package:net_carbons/notification/notification_helpers.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleNotificationAfter30Days() async {
  flutterLocalNotificationsPlugin.cancel(MonthlyNotificationConstants.id);
  print("Notificatio scheduled");
  final locationString = await FlutterTimezone.getLocalTimezone();
  flutterLocalNotificationsPlugin.zonedSchedule(
      MonthlyNotificationConstants.id,
      "Reminder",
      "You have not reduced your emission for a month! Please open netcarbons and be a part of this mission",
      tz.TZDateTime.now(tz.getLocation(locationString))
          .add(const Duration(days: 30)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              NotificationString.defaultChannelId,
              NotificationString.defaultChannelName)),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);
}

Future<void> showANotification() async {
  flutterLocalNotificationsPlugin.show(
      1,
      'title',
      'body',
      const NotificationDetails(
        android: AndroidNotificationDetails(NotificationString.defaultChannelId,
            NotificationString.defaultChannelName),
      ),
      payload: "PAYLODA");
}

//DateTime.now().add(Duration(days: 30))

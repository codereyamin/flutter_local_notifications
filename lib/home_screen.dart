import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_work/main.dart';
import 'package:timezone/timezone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void showNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            "tuhin notifications id", "tuhin notifications channel Name",
            priority: Priority.max, importance: Importance.max);

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    // instent
    // await notificationsPlugin.show(0, 'Sample Notification title',
    //     "Sample Notification body", notificationDetails);
    DateTime timeIs = DateTime.now().add(const Duration(seconds: 5));
    await notificationsPlugin.zonedSchedule(
        0,
        'Sample Notification title',
        "Sample Notification body",
        TZDateTime.from(timeIs, local),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        notificationDetails,
        payload: "Tuhin is my name");
  }

  void checkForNotification() async {
    NotificationAppLaunchDetails? details =
        await notificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? respose = details.notificationResponse;
        if (respose != null) {
          String? payload = respose.payload;
          log("app is runing is notification is $payload");
        }
      }
    }
  }

  @override
  void initState() {
    checkForNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: showNotification,
          child: const Icon(Icons.notification_add)),
    );
  }
}

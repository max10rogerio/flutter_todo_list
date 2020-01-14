import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationWrapper {
  static final channelId = 'flutter_todolist';
  static final channelName = 'Flutter - Todo List';
  static final channelDescription = 'Notifications of Flutter Todo List';
  static final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  static final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId, channelName, channelDescription,
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  static final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  final FlutterLocalNotificationsPlugin instancePlugin =
      FlutterLocalNotificationsPlugin();

  NotificationWrapper() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    instancePlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(
      int id, String body, DateTime scheduleTime) async {
    await instancePlugin.schedule(
        id, null, body, scheduleTime, platformChannelSpecifics);
  }

  Future<void> cancelScheduleNotification(int idNotification) async {
    await instancePlugin.cancel(idNotification);
  }
}

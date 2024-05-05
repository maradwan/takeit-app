import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void showNotificationAndroid(String title, String value) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'Channel Name',
        channelDescription: 'Channel Description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    int notification_id = 1;
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(notification_id, title, value, notificationDetails, payload: 'Not present');
  }


  //template code for showin notifixation in iOS
  // void showNotificationIos(String title, String value) async {
    // const IOSNotificationDetails iOSPlatformChannelSpecifics =
    // IOSNotificationDetails(
    //     presentAlert: bool?,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    //     presentBadge: bool?,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    //     presentSound: bool?,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    //     sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
    //     badgeNumber: int?, // The application's icon badge number
    //     attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
    //     subtitle: String?, //Secondary description  (only from iOS 10 onwards)
    //     threadIdentifier: String? (only from iOS 10 onwards)
    // );

    // int notification_id = 1;

    // const NotificationDetails platformChannelSpecifics =
    // NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    // await flutterLocalNotificationsPlugin
    //     .show(notification_id, title, value, notificationDetails, payload: 'Not present');
  // }

  }



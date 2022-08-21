import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class Notify {
  static Notify? _instance;
  static Notify get instance => _instance ??= Notify();

  final _notifications = FlutterLocalNotificationsPlugin();
  int index = 0;

  Future<Notify> init() async {
    const settings = InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_launcher'),
        iOS: IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false));
    await _notifications.initialize(settings);
    WidgetsFlutterBinding.ensureInitialized();
    Workmanager().initialize(() => Workmanager().executeTask(executeTask),
        isInDebugMode: kDebugMode);
    Workmanager().registerPeriodicTask(
      "background_notification",
      "background notification",
      frequency: const Duration(seconds: 5),
    );
    return this;
  }

  Future<bool> executeTask(
      String taskName, Map<String, dynamic>? inputData) async {
    await onBackgroundUpdate();
    return true;
  }

  Future<void> onBackgroundUpdate() async {
    showNotification(title: 'ddddd', body: 'ddddd');
  }

  Future<bool?> requestPermission() async {
    return await (_notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestPermission() ??
        _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              sound: true,
              alert: true,
              badge: true,
            ));
  }

  Future<int> showNotification(
      {required String title,
      required String body,
      String? payload,
      bool isAdvertising = false}) async {
    final id = _id;
    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          isAdvertising ? 'advertising' : 'default',
          isAdvertising ? 'advertising' : 'default',
          importance:
              isAdvertising ? Importance.defaultImportance : Importance.high,
          priority: isAdvertising ? Priority.high : Priority.max,
          showWhen: isAdvertising ? false : true,
        ),
        iOS: const IOSNotificationDetails(),
      ),
      payload: payload,
    );
    return id;
  }

  int get _id => index++;
}

part of 'notify.dart';

extension NotifyPlugin on Notify {
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
}

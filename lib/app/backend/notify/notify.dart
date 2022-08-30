import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:minima/app/models/notify/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth.dart';
import '../myplant/myplant.dart';

part 'notify.sys.dart';

class Notify {
  static Notify? _instance;
  static Notify get instance => _instance ??= Notify();

  final _notifications = FlutterLocalNotificationsPlugin();
  late Future<void> initialize;
  late SharedPreferences storage;
  int _index = 0;
  NotifySettings? _settings;
  bool initialized = false;

  int get _id => _index++;

  Notify() {
    initialize = () async {
      storage = await SharedPreferences.getInstance();
      initialized = true;
    }();
  }

  Future<Notify> init() async {
    await (initialize = _init());
    return this;
  }

  Future<void> _init() async {
    const settings = InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_launcher'),
        iOS: IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false));
    await _notifications.initialize(settings);
  }

  Future<void> wfi() async {
    if (initialized) return;
    await initialize;
  }

  Future<NotifySettings> get() async {
    if (_settings != null) return _settings!;
    await wfi();
    try {
      final data = storage.getString('notify.settings');
      _settings = data == null
          ? NotifySettings.defaults()
          : NotifySettings.fromJson(jsonDecode(data));
    } catch (e) {
      if (kDebugMode) {
        print('load settings error: $e');
      }
      _settings = NotifySettings.defaults();
    }
    return _settings!;
  }

  Future<void> save() async {
    await wfi();
    _settings ??= NotifySettings.defaults();
    await storage.setString(
        'notify.settings', json.encode((_settings!).toJson()));
  }

  Future<void> update(bool Function(NotifySettings) func) async {
    final cache = await get();
    if (func(cache)) await save();
  }

  Future<void> onBackgroundUpdate() async {
    final now = DateTime.now();
    var cache = await get();

    final diff =
        cache.lastNotify != null ? now.difference(cache.lastNotify!) : null;
    if (diff?.inDays == 0) return;
    final settings = await get();
    if (!settings.enabled || now.hour < settings.time.inHours) return;

    try {
      if (!await Auth.instance.verifyToken()) return;
    } catch (e) {
      if (kDebugMode) print(e);
      return;
    }

    try {
      final plants = await MyPlant.instance.getMyPlants();

      if (plants != null) {
        for (var plant in plants) {
          if (plant.schedule == null) continue;
          for (var schedule in plant.schedule!.items) {
            if (schedule.done) continue;

            await showNotification(
              title: '잠깐만요! ${plant.name}의 ${schedule.localizedName} 일정이 있어요!',
              body: '3분만 투자해서 일정을 완료해주세요!',
            );
          }
        }
      }

      cache.lastNotify = now;
      await save();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}

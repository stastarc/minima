class NotifySettings {
  bool enabled;
  Duration time;
  DateTime? lastNotify;

  NotifySettings({
    required this.enabled,
    required this.time,
  });

  factory NotifySettings.defaults() => NotifySettings(
        enabled: true,
        time: const Duration(hours: 12 + 7),
      );

  NotifySettings.fromJson(Map<String, dynamic> json)
      : enabled = json['enabled'] as bool,
        time = Duration(
          seconds: (json['time'] as num).toInt(),
        ),
        lastNotify = json['last_notify'] != null
            ? DateTime.parse(json['last_notify'] as String)
            : null;

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'time': time.inSeconds,
        'last_notify': lastNotify?.toIso8601String(),
      };
}

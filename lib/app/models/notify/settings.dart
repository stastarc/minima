class NotifySettings {
  bool enabled;
  Duration time;

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
        );

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'time': time.inSeconds,
      };
}

import 'package:minima/shared/number_format.dart';

class ScheduleInitData {
  final Map<String, Duration?> cycle;

  ScheduleInitData({
    required this.cycle,
  });

  ScheduleInitData.fromJson(Map<String, dynamic> json)
      : cycle = (json['cycle'] as Map<String, dynamic>).map((k, v) =>
            MapEntry(k, v == null ? null : Duration(seconds: v.toInt())));
}

class ScheduleToDoItme {
  static final Map<String, String> localizedNames = {
    'water': '물주기',
    'fertilize': '영양제',
    'prune': '가지치기',
    'harvest': '수확',
  };

  final String name;
  final DateTime last;
  final DateTime next;
  final Duration cycle;
  final bool done;

  const ScheduleToDoItme({
    required this.name,
    required this.last,
    required this.next,
    required this.cycle,
    required this.done,
  });

  String get localizedName => localizedNames[name] ?? "알수없음";

  ScheduleToDoItme.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        last = DateTime.parse(json['last']),
        next = DateTime.parse(json['next']),
        cycle = Duration(seconds: json['cycle'].toInt()),
        done = json['done'] as bool;
}

class ScheduleToDoData {
  final int plantId;
  final DateTime today;
  final List<ScheduleToDoItme> items;

  const ScheduleToDoData({
    required this.plantId,
    required this.today,
    required this.items,
  });

  List<String> todo(DateTime? today) {
    today ??= this.today;

    return items
        .where((item) {
          final diff = today!.difference(item.last).inDays;
          return diff == 0 || (diff > 0 && diff % item.cycle.inDays == 0);
        })
        .map((item) => item.name)
        .toList();
  }

  bool isDone(String schedule, DateTime date) {
    return items.any((item) =>
        item.name == schedule &&
        (item.last.isAfter(date) ||
            (date.difference(item.last).inDays == 0 && item.done)));
  }

  ScheduleToDoData.fromJson(Map<String, dynamic> json)
      : plantId = json['plant_id'] as int,
        today = DateTime.parse(json['today']),
        items = (json['items'] as List)
            .map((e) => ScheduleToDoItme.fromJson(e as Map<String, dynamic>))
            .toList();
}

String lastScheduleToString(Map<String, DateTime> schedules) {
  var sb = StringBuffer();
  schedules.forEach((k, v) => sb.write('$k:${isoDateFormat(v)}'));
  return sb.toString();
}
